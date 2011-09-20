class NetworkConnectionsController < ApplicationController
  # GET /network_connections
  # GET /network_connections.json
  def index
    @network_connections = NetworkConnection.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @network_connections }
    end
  end

  # GET /network_connections/1
  # GET /network_connections/1.json
  def show
    @network_connection = NetworkConnection.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @network_connection }
    end
  end

  # GET /network_connections/new
  # GET /network_connections/new.json
  def new
    @network_connection = NetworkConnection.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @network_connection }
    end
  end

  # GET /network_connections/1/edit
  def edit
    @network_connection = NetworkConnection.find(params[:id])
  end

  # POST /network_connections
  # POST /network_connections.json
  def create
    @network_connection = NetworkConnection.new(params[:network_connection])

    respond_to do |format|
      if @network_connection.save
        format.html { redirect_to @network_connection, :notice => 'Network connection was successfully created.' }
        format.json { render :json => @network_connection, :status => :created, :location => @network_connection }
      else
        format.html { render :action => "new" }
        format.json { render :json => @network_connection.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /network_connections/1
  # PUT /network_connections/1.json
  def update
    @network_connection = NetworkConnection.find(params[:id])

    respond_to do |format|
      if @network_connection.update_attributes(params[:network_connection])
        format.html { redirect_to @network_connection, :notice => 'Network connection was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @network_connection.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /network_connections/1
  # DELETE /network_connections/1.json
  def destroy
    @network_connection = NetworkConnection.find(params[:id])
    @network_connection.destroy

    respond_to do |format|
      format.html { redirect_to network_connections_url }
      format.json { head :ok }
    end
  end
end
