class MonitorConfig
  include MongoMapper::Document

  after_create :initialize_tasks
  after_update :update_tasks

  belongs_to :group

  key :name, String, :required => true
  key :frequency, Integer, :default => 10.minutes
  key :locations, Array

  key :availability_sla, Float
  # eg. performance_sla = {'percent' => 0.85, 'metric' => 'dns_time', 'seconds' => 5}
  key :performance_sla,  Hash

  one :issue
  many :tasks, :class_name => "MonitorConfigTask", :as => :monitor_config

  def location_frequency
    (frequency * locations.count).seconds
  end

  def schedule_realtime
    tasks.not_realtime.each do |task|
      config = task.as_config
      tasks.create(config.merge(:next_scheduled_at => Time.now.utc, :realtime => true)) if tasks.realtime.where(config).empty?
    end
  end

  def operation
    _type.underscore.split('_').first
  end
  
  protected
  def initialize_tasks
    unless locations.empty?
      current_time = Time.now.utc
      locations.each_with_index do |location, index|
        add_task(default_task_options.merge(:location => location, :next_scheduled_at => current_time + (index * frequency).seconds))
      end
    end
  end
  
  def update_tasks
    alters = changes

    if alters.has_key?('locations') || alters.has_key?('frequency')
      base_time = calculate_next_task_time
      if alters.has_key?('locations')
        prev, after = alters['locations']
        deleted_locations, new_locations = prev - after, after - prev

        delete_tasks(:location => deleted_locations)

        new_locations.each do |location|
          add_task(default_task_options.merge(:location => location))
        end
      end
      reschedule_tasks(base_time)
    end
  end

  def add_task options
    self.tasks << MonitorConfigTask.new(options)
  end
  
  # FIXME: how to handle the removed tasks, right now just delete
  def delete_tasks conditions
    tasks.where(conditions).map(&:destroy)
  end
  
  def reschedule_tasks base_time = Time.now.utc
    tasks.not_realtime.each_with_index do |task, index|
      task.update_attribute(:next_scheduled_at, base_time + (index * frequency).seconds)
    end
  end
  
  def calculate_next_task_time
    [tasks.not_realtime.ordered.first.next_scheduled_at - frequency_was + frequency, Time.now.utc].max
  end

  # should be overrided by inheritance class if more options needed
  def default_task_options
    {:reatime => false}
  end
end
