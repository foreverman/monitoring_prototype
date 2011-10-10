module Sample
  class Error
    include MongoMapper::Document

    belongs_to :monitor_config

    key :url,       String
    key :location,  String

    key :error_code
    key :error_type, String
    key :message
    key :meta_data
    key :task

    key :timestamp, Integer

    def self.from_http params, body
      self.new(
        :timestamp => params['t'].to_f/1000,
        :url       => params['u'],
        :location  => params['l'],
        :monitor_config_id => params['i'].to_mongoid,
        :error_type => body['type'],
        :error_code => body['code'],
        :message    => body['message'],
        :meta_data  => body['meta-data'],
        :task       => body['task']
      )
    end

    def store
      save
    end

  end
end
