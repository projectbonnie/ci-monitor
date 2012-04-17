require 'jenkins-remote-api'

module CI
  module Endpoint
    class Jenkins
    
      def poll_state
        {state: Ci::Jenkins.new(APP_CONFIG['ci_host']).current_status_on_job(APP_CONFIG['job_name']), build_number: nil}
      end
    
    end
  end
end
