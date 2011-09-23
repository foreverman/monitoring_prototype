class TrendingsController < ApplicationController
  def show
    @monitors = current_user.monitors
    @monitor_config = MonitorConfig.find params[:id]
    @averages = Sample::HttpDaily.average_metrics(@monitor_config)
    @samples = "Sample::#{@monitor_config.type.classify}".constantize.all 
  end
end
