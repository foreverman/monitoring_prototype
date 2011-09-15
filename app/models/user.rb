class User
  include MongoMapper::Document
  
  key :name
  key :email

end
