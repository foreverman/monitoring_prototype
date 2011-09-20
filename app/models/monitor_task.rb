class MonitorTask < ActiveRecord::Base
  belongs_to :monitor_profile
  belongs_to :location
  
  def as_json(options={})
    {
      :url => monitor_profile.url,
      :task => 'webpage',
      :id => id,
      :network_connection => monitor_profile.network_connection.name,
      :browser => monitor_profile.browser.name
    }
  end
  class << self
    def next!(location_name)
      location = Location.find_by_name(location_name)
      if location 
        task = where('location_id = ? and next_scheduled_at < ?', location.id, Time.current).order(:next_scheduled_at).includes(:monitor_profile, :location).first
        if task
          task.next_scheduled_at = Time.current + task.monitor_profile.location_frequency
          task.save
          task
        end
      end
    end
  end
end
