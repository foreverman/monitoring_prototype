class MonitorConfig
  include MongoMapper::Document

  after_create :initialize_tasks

  belongs_to :group

  key :name, String, :required => true
  key :url, String, :required => true
  key :frequency, Integer, :default => 10.minutes
  key :browser, String, :default => 'firefox'
  key :locations, Array
  key :bandwidth

  many :tasks, :class_name => "MonitorConfigTask"

  def location_frequency
    (frequency * locations.count).seconds
  end

  #TODO
  def task_type
    "httpservice"
  end

  private
  def initialize_tasks
    unless locations.empty?
      current_time = Time.now.utc
      locations.each_with_index do |location, index|
        last_scheduled_at = current_time + (index * frequency).seconds
        task = MonitorConfigTask.new(
          :next_scheduled_at => last_scheduled_at,
          :location => location,
          :browser => browser,
          :realtime => false
        )
        self.tasks << task
      end
    end
  end
end
