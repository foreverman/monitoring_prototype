%w{base ping webpage}.each do |name|
  require "persistence/#{name}"
end
