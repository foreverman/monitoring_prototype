class String
  
  def to_milli_secs
    to_time.to_i * 1000
  end
  
  def to_mongoid
    BSON::ObjectId.from_string(self) 
  end

  def to_boolean
    if !['true', 'false'].include?(self)
      raise "invalid value '#{self}' for Boolean"
    end
    self == 'true'
  end
  
end
