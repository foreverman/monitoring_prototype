class SamplesController < ApplicationController
  # expect parameters
  # :browsers => Array, eg: ["ie", "firefox"] or ['firefox']
  # :location => String, eg: 'aws-us-east'
  # :type => Array, eg: ['webpage', 'http'] or ['webpage] -- right now we can ignor this parameter
  def fetch
    render :json => MonitorConfig.next_task params
  end
end
