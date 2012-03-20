module CI
  module Jenkins
    require 'jenkins-remote-api'
    class MonitorJob
      
      SUCCESS='success'
      FAILURE='failure'
      BUILDING='building'
      
      def initialize
        poll_state
        @initialized = true
      end
      
      def start
        
        scheduler = Rufus::Scheduler.start_new

        i=0;
        scheduler.every(APP_CONFIG['poll_interval']) do
          poll_state
          puts "STATE IS: #{@current_state}"
        end
        
        scheduler.join
        
      end
      
      def poll_state
        change_state(Ci::Jenkins.new(APP_CONFIG['ci_host']).current_status_on_job APP_CONFIG['job_name'])
      end
      
      def change_state(state)
        return if state == @current_state
        @current_state = state
        mark_state
        play_sound if (APP_CONFIG['play_sounds'] and @initialized)
      end
      
      def mark_state
        case @current_state
        when SUCCESS
          puts "state changed to SUCCESS"
        when FAILURE
          puts "state changed to FAILURE"
        when BUILDING
          puts "state changed to BUILDING"
        else
          puts "Nothing to do for state: #{@current_state}"
        end
      end
      
      def play_sound
        sound = APP_CONFIG['sounds'][@current_state]
        system("playsound #{sound}") unless sound.nil?
      end
    end
  end
end
