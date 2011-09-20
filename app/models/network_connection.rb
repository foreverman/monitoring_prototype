class NetworkConnection < ActiveRecord::Base
  has_many :monitor_profiles
end
