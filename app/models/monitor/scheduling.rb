class MonitorConfig
  after_create :initialize_task
  
  one :task, :class_name => "MonitorConfigTask"
  
  def self.next_task options
    task = MonitorConfig.where('task.next_scheduled_at' => { "$lt" => Time.now.utc }, :browser => options['b'], 'task.next_scheduled_location' => options['l'] ).first
    if task
      task.after_scheduled
      [task.as_task]
    else
      []
    end
  end
  
  def initialize_task
    self.task = MonitorConfigTask.new(:next_scheduled_location => locations.first, :next_scheduled_at => Time.now.utc)
    self.save
  end
  
  def as_task
    { :url => url, :browser => browser, :bandwidth => {:bwDown => bandwidth}, :indexId => BSON::ObjectId.new, :operations => 'webpage', :bundle => false }
  end
  
  def after_scheduled
    task.last_scheduled_at = Time.now.utc
    task.next_scheduled_at = Time.now.utc + frequency.seconds
    task.last_scheduled_location = task.next_scheduled_location
    task.next_scheduled_location = locations[locations.index(task.last_scheduled_location).next % locations.length]
    self.save
  end
end
