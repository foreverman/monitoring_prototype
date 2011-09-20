class MonitorTasksController < ApplicationController
  def fetch
    task = MonitorTask.next(params[:location])
    render :json => task
  end
end
