module Sample
  class WebpageDaily
    include MongoMapper::Document

    belongs_to :monitor_config

    key :url,      String
    key :location, String
    key :browser,  String
    key :bandwidth,String

    key :time_to_display
    key :time_to_title
    key :time_to_interact
    key :first_paint

    key :timestamp, Integer 

    key :sample_count, Integer, :default => 0

    key :yottaa_score, Integer


    def self.store(webpage)
      inc = {
        :time_to_display => webpage.time_to_display, 
        :time_to_title => webpage.time_to_title, 
        :time_to_interact => webpage.time_to_interact, 
        :first_paint => webpage.first_paint,
        :yottaa_score => webpage.yottaa_score,
        :sample_count => 1
      }
      self.collection.update(
        {
          :url => webpage.url, 
          :monitor_config_id => webpage.monitor_config_id, 
          :location => webpage.location,
          :browser => webpage.browser,
          :bandwidth => webpage.bandwidth,
          :timestamp => Time.at(webpage.timestamp).beginning_of_day.to_i
        },
        {'$inc' => inc},
        :upsert => true
      )

    end

  end
end
