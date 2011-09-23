class MonitorConfigTask
  include MongoMapper::Document

  belongs_to :monitor_config, :polymorphic => true

  key :location
  key :next_scheduled_at
  key :realtime
  key :browser
  key :type, String
  key :scheduling, Boolean, :default => false
  
  delegate :location_frequency, :bandwidth, :to => :monitor_config

  def as_json
    monitor_config.as_task
  end

  class << self
    def next!(params)
      # add lock to the task
      begin
        task_doc = self.collection.find_and_modify(
          :query  => {
            "location" => params['l'],
            'scheduling' => false,
            'next_scheduled_at' => {'$lt' => Time.now.utc},
            'browser' => {'$in' => [nil, params['b']].uniq}
            # '$or' => [
            #       { 'type' => {'$in' => params['o'].split(',') } },
            #       { 'type' => {'$in' => params['o'].split(',') }
            #         #, 'browser' => {'$in' => params['browsers']} 
            #       }
            #     ]
          },
          :sort   => [ ["next_scheduled_at", 1] ], # ascending
          :update => { '$set' => { "scheduling" => true } }
        )
      rescue Mongo::OperationFailure => e
        return []
      end

      # calculate after scheduled data, update and unlock the task
      begin
        task = self.find(task_doc['_id'])
        update_params = {"scheduling" => false, "next_scheduled_at" => task.next_scheduled_at + task.location_frequency}
        task.update_attributes(update_params)
        [task.as_json]
      rescue Exception => e
        self.collection.update({'_id' => task_doc['_id']}, {'$set' => { "scheduling" => false }})
        []
      end
    end
  end
end
