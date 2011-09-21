module SampleGenerator
  def self.generate_webpage options = {}
    params = 
    {
      'u' => options[:url],
      't' => Time.now.utc.to_i,
      'l' => options[:location],
      'b' => options[:browser],
      'w' => options[:bandwidth],
      'i' => options[:monitor_config_id]
    }

    seed = 100
    next_rand = lambda{seed ||= 0; seed += rand(1024)}
    body = 
    {
      'log' => {
          'paintEvents' => [
            {
              'timeOffset' => 54
            }
          ],
          'pages' => [
            {
              'pageTimings' => {
                'onTitleChange' => 110,
                'onContentLoad' => next_rand.call,
                'onLoad'        => next_rand.call
              }
            }
          ]
        },
      'yottaa' => {
        'uxScore' => 80
      }
    }
    Sample::Webpage.from_http(params, body)
  end
end

if __FILE__ == $0
  require File.expand_path(File.join(File.dirname(__FILE__),'..','config','environment'))
  url = 'http://www.baidu.com'
  mc = MonitorConfig.first(:name => 'My Monitor Config', :url => url) || MonitorConfig.create(:name => 'My Monitor Config', :url => url, :locations => ['aws-us-east', 'aws-us-west'])
  wp = SampleGenerator.generate_webpage(:url => url, :location => mc.locations.first, :browser => mc.browser, :bandwidth => 500, :monitor_config_id => mc.id.to_s)
  wp.store
end
