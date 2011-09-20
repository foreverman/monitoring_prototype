module Sample
  class Webpage 
    include MongoMapper::Document

    key :url,      String
    key :location, String
    key :browser,  String
    key :bandwidth,String

    key :time_to_display
    key :time_to_title
    key :time_to_interact
    key :first_paint

    key :timestamp, Integer 

    key :yottaa_score, Integer

    key :status,  String 

    def self.from_http params, body
      metrics = parse_metrics_from(body)

      self.new({
        :timestamp => params['t'],
        :url       => params['u'],
        :location  => params['l'],
        :browser   => params['b'],
        :bandwidth => params['w']}.merge(metrics)
      ) 
    end

    def self.parse_metrics_from body
      metrics = {}
      if fail_sample?(body)
        metrics[:status] = 'failed'
        metrics[:error_code] = parse_error_code(body)
        metrics[:error_type] = parse_error_type(body)
        metrics[:message] = parse_error_message(body)
        metrics[:meta_data] = parse_error_meta_data(body)
      else
        metrics[:status] = 'success'
        metrics[:time_to_display] = parse_time_to_display(body)
        metrics[:time_to_title] = parse_time_to_title(body)
        metrics[:time_to_interact] = parse_time_to_interact(body)
        metrics[:first_paint] = parse_first_paint(body)
        metrics[:yottaa_score] = parse_yottaa_score(body)
      end
      metrics
    end

    def self.parse_first_paint body
      (body['log']['paintEvents'].first['timeOffset'] rescue nil)|| -1      
    end
    
    def self.parse_time_to_title body
      (body['log']['pages'].first['pageTimings']['onTitleChange'] rescue nil) || -1            
    end
    
    def self.parse_time_to_display body
      body['log']['pages'].first['pageTimings']['onContentLoad'] || -1
    end
    
    def self.parse_time_to_interact body
      body['log']['pages'].first['pageTimings']['onLoad'] || -1
    end 

    def self.parse_yottaa_score body
      body['yottaa']['uxScore']
    end

    def self.fail_sample? body
      body['error']
    end

    def self.parse_error_code body
      body['error']['code']
    end

    def self.parse_error_type body
      body['error']['type']
    end

    def self.parse_error_message body
      body['error']['message']
    end

    def self.parse_error_meta_data body
      body['error']['meta-data']
    end

  end
end
