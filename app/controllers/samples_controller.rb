class SamplesController < ApplicationController
  # expect parameters
  # :browsers => Array, eg: ["ie", "firefox"] or ['firefox']
  # :location => String, eg: 'aws-us-east'
  # :type => Array, eg: ['webpage', 'http'] or ['webpage] -- right now we can ignor this parameter
  def fetch
    render :json => { :code => 'OK', :tasks => MonitorConfigTask.next!(params)}, :status => 200
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
