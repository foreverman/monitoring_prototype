require 'persistence'
module Sample
  class Base 

    def self.inherited klass
      klass.send :include, "Persistence::#{klass.to_s.split('::')[-1]}".constantize 
    end

  end
end
