class Group
  include MongoMapper::Document

  belongs_to :user
  many :monitor_configs


end
