class SamplesController < ApplicationController
  # expect parameters
  # :browsers => Array, eg: ["ie", "firefox"] or ['firefox']
  # :location => String, eg: 'aws-us-east'
  # :type => Array, eg: ['webpage', 'http'] or ['webpage] -- right now we can ignor this parameter
  def fetch
    render :json => { :code => 'OK', :tasks => MonitorConfig.next!(params)}, :status => 200
  end

  def create
    body_str = request.body.read
    body_hash = ActiveSupport::JSON.decode(body_str)
    sample = Sample.from_http(params, body_hash)
    sample.store
    render :json => {:code => 'OK', :tasks => []}, :status => 200
  end

  def show 
    @samples = Sample::Webpage.all
  end
end
