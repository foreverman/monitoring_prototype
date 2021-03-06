class HttpMonitor < MonitorConfig
  
  key :url
  key :method, String, :in => [ 'GET', 'POST', 'PUT', 'DELETE'], :default => 'GET'
  key :bandwidth
  
  def as_task
    {
      :url => url,
      :bindwidth => {:bwDown => bandwidth},
      :indexId => id,
      :operations => "#{operation}-#{method.downcase}",
      :bundle => false
    }
  end

  def metrics
    %w{connection first_byte last_byte size}
  end
end
