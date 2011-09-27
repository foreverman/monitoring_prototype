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

    def self.average_metrics(monitor_config, options = {})
      start_at = options[:start_at] || 1.months.ago.utc.beginning_of_day.to_i
      end_at = options[:end_at] || Time.now.utc.beginning_of_day.to_i
      metrics = options[:metrics] || %w{connection first_byte last_byte size}
      other_fields = ['sample_count'] 
      samples = where(
        :monitor_config_id => monitor_config.id, 
        :timestamp => {'$lte' => end_at, '$gte' => start_at}).fields(metrics + other_fields).all

      total_sample_count = 0
      sum_hash = 
      samples.inject({}) do |result, sample|
        total_sample_count += sample.sample_count
        metrics.each do |m|
          result[m] ||= 0
          result[m] += sample.send(m)
        end
        result
      end
      sum_hash.each {|k, v| sum_hash[k] = sum_hash[k].to_f / total_sample_count}
      sum_hash
    end
  end
end
