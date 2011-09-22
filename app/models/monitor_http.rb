class MonitorHttp < MonitorConfig
  
  key :type, String, :default => 'http'
  key :url
  key :method, String, :in => [ 'GET', 'POST', 'PUT', 'DELETE'], :default => 'GET'
  key :bandwidth
  
  def as_task
    {
      :url => url,
      :bindwidth => {:bwDown => bandwidth},
      :indexId => id,
      :operations => type,
      :bundle => false
    }
  end
  
  protected
  def initialize_tasks
    unless locations.empty?
      current_time = Time.now.utc
      locations.each_with_index do |location, index|
        last_scheduled_at = current_time + (index * frequency).seconds
        task = MonitorConfigTask.new(
          :next_scheduled_at => last_scheduled_at,
          :location => location,
          :type => type,
          :realtime => false
        )
        self.tasks << task
      end
    end
  end
end