module Sample
  class Error
    include MongoMapper::Document

    belongs_to :monitor_config

    key :url,       String
    key :location,  String
    key :browser,   String
    key :bandwidth, String

    key :type,      String
    key :error_code
    key :error_type
    key :message
    key :meta_data
    key :task

    key :timestamp, Integer

  end
end
