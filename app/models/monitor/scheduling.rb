class MonitorConfig
  after_create :initialize_task
  
  one :task, :class_name => "MonitorConfigTask"
  
  def initialize_task
    self.task = MonitorConfigTask.new(:next_scheduled_location => locations.first, :next_scheduled_at => Time.now.utc)
    self.save
  end
  
  
end