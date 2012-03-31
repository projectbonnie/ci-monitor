module CI
  module Jenkins
    require 'jenkins-remote-api'
    class MonitorJob
      
      SUCCESS='success'
      FAILURE='failure'
      BUILDING='building'
      
      def initialize
        @light = Blinky.new.light
        @light.init_blink
        poll_state
        @initialized = true
      end
      
      def start
        
        scheduler = Rufus::Scheduler.start_new

        i=0;
        scheduler.every(APP_CONFIG['poll_interval']) do
          poll_state
          puts "STATE IS: #{@current_state}, IS_WORKING: #{@is_working}"
        end
        
        scheduler.join
        
      end
      
      def poll_state
        change_state(Ci::Jenkins.new(APP_CONFIG['ci_host']).current_status_on_job APP_CONFIG['job_name'])
      end
      
      def change_state(state)
        return if state == @current_state
        set_is_working
        @current_state = state
        mark_state
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
          @light.blinking = {active: false}
          @light.success!
        when FAILURE
          @light.blinking = {active: false}
          @light.failure!
          puts "state changed to FAILURE"
        when BUILDING
          @light.blinking = {active: true, status: @is_working}
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
