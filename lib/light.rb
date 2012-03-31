module Blinky
  class Light
    attr_accessor :blinking

    def init_blink
        @blinking = {active:false}

        scheduler = Rufus::Scheduler.start_new

        scheduler.every(APP_CONFIG['blink_interval']) do
          if (blinking[:active])
            off! if (blinking[:active])
            sleep APP_CONFIG['blink_off_time']
            send((blinking[:status]+'!').to_sym) if (blinking[:active])
          end
        end

    end
  end
end
