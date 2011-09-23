class MonitorConfig
  include MongoMapper::Document

  after_create :initialize_tasks

  belongs_to :group

  key :name, String, :required => true
  key :frequency, Integer, :default => 10.minutes
  key :locations, Array

  many :tasks, :class_name => "MonitorConfigTask", :as => :monitor_config

  def location_frequency
    (frequency * locations.count).seconds
  end

end
