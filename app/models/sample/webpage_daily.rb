module Sample
  class WebpageDaily
    include MongoMapper::Document
    include Attribute
    include SLA

    belongs_to :monitor_config

    key :url,      String
    key :location, String
    key :browser,  String
    key :bandwidth,String

    numeric_attribute :time_to_display, :time_to_title, :time_to_interact, :first_paint

    key :timestamp, Integer 

    key :sample_count, Integer, :default => 0

    key :yottaa_score, Integer

    def self.store(webpage)
      inc = {
        "time_to_display.value" => webpage.time_to_display, 
        "time_to_title.value" => webpage.time_to_title, 
        "time_to_interact.value" => webpage.time_to_interact, 
        "first_paint.value" => webpage.first_paint,
        "time_to_display.sum_of_sqr" => webpage.time_to_display**2, 
        "time_to_title.sum_of_sqr" => webpage.time_to_title**2, 
        "time_to_interact.sum_of_sqr" => webpage.time_to_interact**2, 
        "first_paint.sum_of_sqr" => webpage.first_paint**2,
        "yottaa_score" => webpage.yottaa_score,
        "sample_count" => 1,
      }
      compute_sla webpage, inc

      self.collection.update(
        {
          :monitor_config_id => webpage.monitor_config_id, 
          :location => webpage.location,
          :timestamp => Time.at(webpage.timestamp).utc.beginning_of_day.to_i
        },
        {'$inc' => inc},
        :upsert => true
      )
    end

  end
end
