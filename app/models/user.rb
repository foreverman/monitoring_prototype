class User
  include MongoMapper::Document
  
  key :name
  key :email
  one :group
  
  delegate :monitors, :to => :group, :allow_nil => true
end
