module Sample
  class HttpDaily
    include MongoMapper::Document
    include Attribute
    include SLA

    belongs_to :monitor_config

    key :url,      String
    key :location, String
    key :browser,  String
    key :bandwidth,String

    numeric_attribute :connection, :first_byte, :last_byte, :size

    key :timestamp, Integer

    key :sample_count, Integer, :default => 0

    def self.store(http)
      inc = {
        'connection.value' => http.connection, 
        'first_byte.value' => http.first_byte, 
        'last_byte.value' => http.last_byte, 
        'size.value' => http.size,
        'sample_count' => 1
      }
      compute_sla http, inc
      
      self.collection.update(
        {
          :monitor_config_id => http.monitor_config_id, 
          :location => http.location,
          :timestamp => Time.at(http.timestamp).utc.beginning_of_day.to_i
        },
        {'$inc' => inc},
        :upsert => true
      )
    end

  end
end
