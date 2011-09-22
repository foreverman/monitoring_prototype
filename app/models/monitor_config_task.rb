class MonitorConfigTask
  include MongoMapper::Document

  belongs_to :monitor_config

  key :location
  key :next_scheduled_at
  key :realtime
  key :browser
  key :scheduling, Boolean, :default => false

  def as_json
    {
      :url => monitor_config.url,
      :bindwidth => {:bwDown => monitor_config.bandwidth},
      :browser => browser,
      :indexId => monitor_config_id.to_s,
      :operations => monitor_config.task_type,
      :bundle => false
    }
  end

  class << self
    def next!(params)
      # add lock to the task
      begin
        task = self.collection.find_and_modify(
          :query  => {
            "location" => params['l'],
            #"browser" => {'$in' => params[:browsers]},
            "scheduling" => false,
            "next_scheduled_at" => {"$lt" => Time.now.utc}
          },
          :sort   => [ ["next_scheduled_at", 1] ], # ascending
          :update => { '$set' => { "scheduling" => true } }
        )
      rescue Mongo::OperationFailure => e
        return []
      end

      # calculate after scheduled data, update and unlock the task
      begin
        task = self.find(task['_id'])
        update_params = {"scheduling" => false, "next_scheduled_at" => task.next_scheduled_at + task.monitor_config.location_frequency}
        self.collection.find_and_modify(
          :query => {"_id" => task.id},
          :sort   => [ ["next_scheduled_at", 1] ], # ascending
          :update => {"$set" => update_params }
        )
        [task.as_json]
      rescue Exception => e
        self.collection.find_and_modify(
          :query => {"_id" => task.id},
          :update => {"$set" => {"scheduling" => false}}
        )
        []
      end
    end
  end
end
