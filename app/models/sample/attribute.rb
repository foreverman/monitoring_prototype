module Sample
  module Attribute
    def self.included base
      base.extend ClassMethods
    end

    module ClassMethods
      def numeric_attribute *attrs
        @@numeric_attrs ||= [] 
        attrs.each do |attr|
          one attr, :class_name => "Sample::NumericAttribute"
          @@numeric_attrs << attr
        end
      end
    end
  end
end
