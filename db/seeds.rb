# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Emanuel', :city => cities.first)
[User, Location, Browser, NetworkConnection].each do |m|
  m.delete_all
end
User.create(:email => 'sliu@yottaa.com')

[['aws-us-east', 'Washington DC'], ['aws-eu-west', 'Dublin']].each do |name, description|
  Location.create(:name => name, :label => description)
end

[['ie', 'Internet Explorer'], ['chrome', 'Chrome'], ['firefox', 'Firefox']].each do |name, description|
  Browser.create(:name => name, :description => description)
end

[['dsl', 'DSL (1.5 Mbps/384 Kbps 50ms RTT)'], ['56K', '56K Dial-Up(49 Kbps/30 Kbps 120ms RTT)']].each do |name, description|
  NetworkConnection.create(:name => name, :description => description)
end
