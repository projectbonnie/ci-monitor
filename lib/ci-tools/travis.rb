require 'json'
require 'net/http'

module CI
  module Endpoint
    class Travis
    
      def poll_state
        uri = URI("#{APP_CONFIG['ci_host']}/#{APP_CONFIG['repository_name']}/#{APP_CONFIG['job_name']}.json")
        result = JSON.parse(Net::HTTP.get(uri))
        
        case result['last_build_status']
        when 0 
          CI::MonitorJob::SUCCESS
        when 1
          CI::MonitorJob::FAILURE
        else
          if (result['last_build_started_at'] && result['last_build_finished_at'].nil?)
            CI::MonitorJob::BUILDING
          else
            CI::MonitorJob::UNKNOWN
          end
        end
      end
    
    end
  end
end
