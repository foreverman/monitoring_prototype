class MonitorProfilesController < ApplicationController
  # GET /monitor_profiles
  # GET /monitor_profiles.json
  def index
    @monitor_profiles = MonitorProfile.all(:include => [:browser, :network_connection, :locations])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @monitor_profiles }
    end
  end

  # GET /monitor_profiles/1
  # GET /monitor_profiles/1.json
  def show
    @monitor_profile = MonitorProfile.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @monitor_profile }
    end
  end

  # GET /monitor_profiles/new
  # GET /monitor_profiles/new.json
  def new
    @monitor_profile = MonitorProfile.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @monitor_profile }
    end
  end

  # GET /monitor_profiles/1/edit
  def edit
    @monitor_profile = MonitorProfile.find(params[:id])
  end

  # POST /monitor_profiles
  # POST /monitor_profiles.json
  def create
    @monitor_profile = MonitorProfile.new(params[:monitor_profile])

    respond_to do |format|
      if @monitor_profile.save
        format.html { redirect_to @monitor_profile, :notice => 'Monitor profile was successfully created.' }
        format.json { render :json => @monitor_profile, :status => :created, :location => @monitor_profile }
      else
        format.html { render :action => "new" }
        format.json { render :json => @monitor_profile.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /monitor_profiles/1
  # PUT /monitor_profiles/1.json
  def update
    @monitor_profile = MonitorProfile.find(params[:id])

    respond_to do |format|
      if @monitor_profile.update_attributes(params[:monitor_profile])
        format.html { redirect_to @monitor_profile, :notice => 'Monitor profile was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @monitor_profile.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /monitor_profiles/1
  # DELETE /monitor_profiles/1.json
  def destroy
    @monitor_profile = MonitorProfile.find(params[:id])
    @monitor_profile.destroy

    respond_to do |format|
      format.html { redirect_to monitor_profiles_url }
      format.json { head :ok }
    end
  end
end
