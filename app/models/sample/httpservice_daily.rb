module Sample
  class HttpserviceDaily
    include MongoMapper::Document

    belongs_to :monitor_config

    key :url,      String
    key :location, String
    key :browser,  String
    key :bandwidth,String

    key :connection
    key :first_byte
    key :last_byte
    key :size

    key :timestamp, Integer

    key :sample_count, Integer, :default => 0

    def self.store(httpservice)
      inc = {
        :connection => httpservice.connection, 
        :first_byte => httpservice.first_byte, 
        :last_byte => httpservice.last_byte, 
        :size => httpservice.size,
        :sample_count => 1
      }
      self.collection.update(
        {
          :monitor_config_id => httpservice.monitor_config_id, 
          :location => httpservice.location,
          :timestamp => Time.at(httpservice.timestamp).utc.beginning_of_day.to_i
        },
        {'$inc' => inc},
        :upsert => true
      )
    end
  end
end
