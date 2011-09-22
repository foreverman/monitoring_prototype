module Sample
  class Http
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
    key :redirects
    key :redirected_url

    key :timestamp, Integer

    key :status, String

    def self.from_http params, body
      self.new(
        :timestamp => params['t'].to_f/1000,
        :url       => params['u'],
        :location  => params['l'],
        :browser   => params['b'],
        :bandwidth => params['w'],
        :monitor_config_id => params['i'].to_mongoid,
        :connection => body['c'],
        :first_byte => body['f'],
        :last_byte  => body['l'],
        :size       => body['s'],
        :redirects  => body['r'],
        :redirected_url => body['u']
      )
    end

    def store
      if save
        HttpDaily.store(self)
      end
    end
  end
end
