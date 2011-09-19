class MonitorsController < ApplicationController 
  def index
    @monitors = MonitorConfig.all
  end
  
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
  
  def edit
    @monitor = MonitorConfig.find(params[:id])
  end
  
  def update
    @monitor = MonitorConfig.find(params[:id])
    if @monitor.update_attributes(params[:monitor])
      redirect_to monitor_path(@monitor)
    else
      redirect_to edit_monitor_path(@monitor)
    end
  end
  
  def destroy
    @monitor = MonitorConfig.find(params[:id])
    @monitor.destroy
    redirect_to monitors_path
  end
end