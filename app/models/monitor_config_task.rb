class MonitorConfigTask
  include MongoMapper::EmbeddedDocument
  
  key :last_scheduled_at
  key :next_scheduled_at
  
  key :last_scheduled_location
  key :next_scheduled_location
  
end