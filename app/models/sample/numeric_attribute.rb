module Sample
  class NumericAttribute
    include MongoMapper::EmbeddedDocument

    key :value,         Integer, :default => 0
    key :count_of_sla,  Integer, :default => 0 # count of samples whose value is bigger than some given value  
  end
end
