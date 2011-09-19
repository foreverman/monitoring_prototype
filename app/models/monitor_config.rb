class MonitorConfig
  include MongoMapper::Document
  
  require_dependency 'monitor/scheduling.rb'

  belongs_to :group
  key :name, String, :required => true
  key :url, String, :required => true
  key :frequency, Integer, :default => 10.minutes
  key :browser, String, :default => 'firefox'
  key :locations, Array
  key :bandwidth

end
