class Group
  include MongoMapper::Document

  belongs_to :user
  many :monitors, :class_name => "MonitorConfig"

end
