module Consumer
  class Dispatch
    module Substitute
      def self.build
        Dispatch.new
      end

      class Dispatch
        def call(event_data)
          dispatched_events << event_data
        end

        def dispatched_events
          @dispatched_events ||= []
        end

        def dispatched?(event_data=nil, &block)
          if event_data.nil?
            block ||= proc { true }
          else
            block ||= proc { |e| event_data == e }
          end

          dispatched_events.any? &block
        end
      end
    end
  end
end
