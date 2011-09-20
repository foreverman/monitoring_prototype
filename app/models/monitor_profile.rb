class MonitorProfile < ActiveRecord::Base
  has_and_belongs_to_many :locations
  has_many :monitor_tasks

  belongs_to :browser
  belongs_to :network_connection

  before_create :init_monitor_tasks
  
  def location_frequency
    frequency * locations.count
  end

  private
  def init_monitor_tasks
    current_time = Time.current
    locations.each_with_index do |l, i|
      last_scheduled_at = current_time + (i * frequency).seconds 
      task = MonitorTask.new(
        :next_scheduled_at => last_scheduled_at,
        :location => l,
        :realtime => false
      )
      self.monitor_tasks << task
    end
  end
end
