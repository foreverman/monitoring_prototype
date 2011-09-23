class TrendingsController < ApplicationController
  def show
    @monitor_config = MonitorConfig.find params[:id]
    sample_class = "Sample::#{@monitor_config.type.classify}".constantize
    sample_daily_class = "Sample::#{@monitor_config.type.classify}Daily".constantize

    @monitors = current_user.monitors
    @averages = sample_daily_class.average_metrics(@monitor_config)
    @samples_daily = sample_daily_class.all(:monitor_config_id => @monitor_config.id)
    @samples = sample_class.all 
  end
end
