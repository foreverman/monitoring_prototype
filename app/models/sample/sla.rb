module Sample
  module SLA
    def self.included base
      base.extend ClassMethods      
    end

    module ClassMethods
      def task_name
        name.underscore.split('_')[0].split('/')[1]
      end

      def compute_sla(sample, inc = {})
        mc = sample.monitor_config
        if !mc.performance_sla.blank?
          mean, standard_deviation = mean_and_standard_deviation(mc)
          metric = sample.send(mc.performance_sla[:metric])
          metric_standard = (metric - mean).to_f / standard_deviation
         
          probability = StandardNormalDistribution.probability_of_lte(metric_standard)
          if probability < mc.performance_sla[:percent]
            inc["#{mc.performance_sla[:metric]}.count_of_sla"] = 1 
          end
        end
      end

      def average_metrics(monitor_config, options = {})
        start_at, end_at = prepare_timespan options
        metrics = options[:metrics] || monitor_config.metrics
        other_fields = ['sample_count'] 
        samples = where(
          :monitor_config_id => monitor_config.id, 
          :timestamp => {'$lt' => end_at, '$gte' => start_at}).fields(metrics + other_fields).all

        total_sample_count = 0
        sum_hash = 
        samples.inject({}) do |result, sample|
          total_sample_count += sample.sample_count
          metrics.each do |m|
            result[m] ||= 0
            result[m] += sample.send(m).value
          end
          result
        end
        sum_hash.each {|k, v| sum_hash[k] = sum_hash[k].to_f / total_sample_count}
        sum_hash
      end

      def availability(monitor_config, options = {})
        start_at, end_at = prepare_timespan options
        query = {
          :monitor_config_id => monitor_config.id,
          :timestamp => {'$lt' => end_at, '$gte' => start_at}
          }

        valid_samples_count = self.name[0..-6].constantize.count(query)
        error_samples_count = Sample::Error.count query.merge({:error_type => task_name})
        valid_samples_count.to_f / (valid_samples_count + error_samples_count)
      end

      def sla(monitor_config, options = {})
        start_at, end_at = prepare_timespan options
        query = {
          :monitor_config_id => monitor_config.id,
          :timestamp => {'$lt' => end_at, '$gte' => start_at}
          }
        metric = monitor_config.performance_sla[:metric]
        other_fields = ['sample_count'] 
        samples = where(query).fields([metric] + other_fields).all

        success_days = samples.inject(0) do |days, s| 
          c = (s.send(metric).count_of_sla.to_f / s.sample_count > monitor_config.performance_sla[:percent]) ? 1 : 0
          days += c
        end
        success_days.to_f / samples.count
      end

      def mean_and_standard_deviation(monitor_config, options = {})
        start_at, end_at = prepare_timespan options
        query = {
          :monitor_config_id => monitor_config.id,
          :timestamp => {'$lt' => end_at, '$gte' => start_at}
        }
        metric = monitor_config.performance_sla[:metric]
        other_fields = ['sample_count'] 
        samples = where(query).fields([metric] + other_fields).all

        return [0, 0] if samples.empty?
        sum_metric = samples.map{|s| s.send(metric).value}.sum
        count_metric = samples.map{|s| s.sample_count}.sum
        mean = sum_metric.to_f / count_metric

        sum_of_square = samples.map{|s| s.send(metric).sum_of_sqr}.sum
        standard_deviation = std_deviation(count_metric, sum_metric, sum_of_square)
        [mean, standard_deviation]
      end

      protected
      def std_deviation count, sum, sum_of_sqr
        Math.sqrt(((count * sum_of_sqr) - (sum**2)).to_f / (count * (count-1)))
      end

      def prepare_timespan options = {}
        start_at = options[:start_at] || 1.months.ago.utc.beginning_of_day.to_i
        end_at = options[:end_at] || Time.now.utc.end_of_day.to_i
        [start_at, end_at]
      end
    end
  end
end
