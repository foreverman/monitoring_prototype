class MonitorWebpage < MonitorConfig
  
  key :url, String, :required => true
  key :browser, String, :in => ['firefox', 'ie', 'chrome'] :default => 'firefox'
  key :bandwidth
  
  def as_task
    {
      :url => url,
      :bindwidth => {:bwDown => bandwidth},
      :browser => browser,
      :indexId => id,
      :operations => operation,
      :bundle => false
    }
  end

  protected
  def default_task_options
    super.merge(:browser => browser)
  end
end