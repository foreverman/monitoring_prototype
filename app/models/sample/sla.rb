module Sample
  module SLA
    def self.included base
      base.extend ClassMethods      
    end

    module ClassMethods
      def compute_sla(sample, inc = {})
        if !sample.monitor_config.performance_sla.blank? && 
            (sample.send(sample.monitor_config.performance_sla[:metric]) < sample.monitor_config.performance_sla[:seconds])
          inc["#{sample.monitor_config.performance_sla[:metric]}.count_of_sla"] = 1 
        end
      end
    end
  end
end
