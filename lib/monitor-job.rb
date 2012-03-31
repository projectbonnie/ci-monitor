module CI
    class MonitorJob
      
      SUCCESS='success'
      FAILURE='failure'
      BUILDING='building'
      UNKNOWN='unknown'
      
      def initialize
        case APP_CONFIG['ci_implementation']
        when 'jenkins'
          @ci_endpoint = CI::Endpoint::Jenkins.new
        when 'travis'
          @ci_endpoint = CI::Endpoint::Travis.new
        end
        
        change_state(@ci_endpoint.poll_state)
        @initialized = true
      end
      
      def start
        
        scheduler = Rufus::Scheduler.start_new

        i=0;
        scheduler.every(APP_CONFIG['poll_interval']) do
          change_state(@ci_endpoint.poll_state)
          
          puts "STATE IS: #{@current_state}, IS_WORKING: #{@is_working}"
        end
        
        scheduler.join
        
      end
            
      def change_state(state)
        return if state == @current_state
        set_is_working
        @current_state = state
        play_sound if (APP_CONFIG['play_sounds'] and @initialized and @current_state != @is_working)
        set_is_working
      end
      
      def set_is_working
        @is_working = @current_state if ([SUCCESS,FAILURE].include? @current_state)
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
