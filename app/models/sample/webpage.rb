module Sample
  class Webpage 
    include MongoMapper::Document

    key :url,      String
    key :location, String
    key :browser,  String

    key :time_to_display
    key :time_to_title
    key :time_to_interact
    key :first_paint

    key :timestamp, Time

    def self.from_http params, body
      self.new body
    end
  end
end
