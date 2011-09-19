class MonitorsController < ApplicationController 
  def new
    @monitor = MonitorConfig.new
  end
  
  def create
    @monitor = MonitorConfig.new(params[:monitor])
    if @monitor.save
      redirect_to monitor_path(@monitor)
    else
      redirect_to new_monitor_path
    end
  end
  
  def show
    @monitor = MonitorConfig.find(params[:id])
  end
  
  def destroy
  end
end