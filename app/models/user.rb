class User
  include MongoMapper::Document
  
  key :name
  key :email
  one :group
  
  delegate :monitors, :to => :group, :allow_nil => true
  after_create :create_group

  def create_group
    group = Group.new
    self.group = group 
    group.save
  end

end
