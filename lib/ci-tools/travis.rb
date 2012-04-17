require 'json'
require 'net/http'

module CI
  module Endpoint
    class Travis
    
      def poll_state

        proxy = Net::HTTP::Proxy('gatekeeper.mitre.org', 80)
        url = URI.parse("#{APP_CONFIG['ci_host']}/#{APP_CONFIG['repository_name']}/#{APP_CONFIG['job_name']}.json")  
        result = JSON.parse(proxy.get_response(url).body) 

#        uri = URI("#{APP_CONFIG['ci_host']}/#{APP_CONFIG['repository_name']}/#{APP_CONFIG['job_name']}.json")
#        result = JSON.parse(Net::HTTP.get(uri))
        
        case result['last_build_status']
        when 0 
          state = CI::MonitorJob::SUCCESS
        when 1
          state = CI::MonitorJob::FAILURE
        else
          if (result['last_build_started_at'] && result['last_build_finished_at'].nil?)
            state = CI::MonitorJob::BUILDING
          else
            state = CI::MonitorJob::UNKNOWN
          end
        end
        
        {state: state, build_number: result['last_build_number']}

      end
    
    end
  end
end
