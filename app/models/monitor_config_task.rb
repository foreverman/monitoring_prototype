class MonitorConfigTask
  include MongoMapper::Document

  belongs_to :monitor_config, :polymorphic => true

  key :location
  key :next_scheduled_at
  key :realtime, Boolean, :default => false
  key :browser
  key :scheduling, Boolean, :default => false

  delegate :location_frequency, :bandwidth, :to => :monitor_config

  scope :illegal, where(:scheduling => true)
  scope :realtime, where(:realtime => true)
  scope :not_realtime, where(:realtime => false)
  scope :ordered, sort(:next_scheduled_at)

  def as_json
    monitor_config.as_task
  end

  def as_config
    {
      :location => location,
      :browser => browser
    }
  end

  def get_next_scheduled_time
    last_time, now = next_scheduled_at, Time.now.utc
    while (next_time = last_time.since(location_frequency)) <= now
      #add logic for processing missing sample points, eg: Rails.logger.debug "#{last_time} sample missing"
      last_time = next_time
    end
    next_time
  end

  # class methods
  class << self
    def next!(location, browsers, operations)
      tasks = []
      operations = operations.map{|o| "#{o}_monitor".camelize }
      begin
        # add lock to the task
        task_doc = self.collection.find_and_modify(
          :query  => {
            "location" => location,
            'scheduling' => false,
            'next_scheduled_at' => {'$lt' => Time.now.utc},
            'monitor_config_type' => {'$in' => operations},
            '$or' => [
                { :browser => nil },      #for http task
                { :browser => browsers }  #for webpage task
              ]
          },
          :sort   => [ [:realtime, -1], ["next_scheduled_at", 1] ], #fetch realtime task first
          :update => { '$set' => { "scheduling" => true } }
        )

        # calculate after scheduled data, update and unlock the task
        if task_doc && task_doc['_id']
          begin
            task = self.find(task_doc['_id'])
            tasks << task.as_json
            if task.realtime?
              task.destroy
            else
              task.update_attributes(:scheduling => false, :next_scheduled_at => task.get_next_scheduled_time)
            end
          rescue Exception => e
            self.collection.update({'_id' => task_doc['_id']}, {'$set' => { "scheduling" => false }})
          end
        end
      rescue Mongo::OperationFailure => e
      end
      tasks
    end
  end
end
