class SamplesController < ApplicationController
  # expect parameters
  # :b => String, eg: 'firefox' -- browsers
  # :l => String, eg: 'aws-us-east' -- location
  # :o => String, eg: 'webpage,http' or 'webpage -- operations
  def fetch
    render :json => { :code => 'OK', :tasks => MonitorConfigTask.next!(params['l'], params['b'], params['o'].split(','))}, :status => 200
  end

  def create
    body_str = request.body.read
    body_hash = ActiveSupport::JSON.decode(body_str)
    samples = Sample.from_http(params, body_hash)
    samples.each {|sample| sample.store}
    render :json => {:code => 'OK', :tasks => []}, :status => 200
  end

  def show 
    @samples = Sample::Webpage.all
  end
end
