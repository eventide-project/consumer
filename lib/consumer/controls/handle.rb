module Consumer
  module Controls
    module Handle
      def self.example
        Example.new
      end

      class Example
        include Messaging::Handle

        def handle(event_data)
          handled_events << event_data
        end

        def handled_events
          @handled_events ||= []
        end

        def handled?(event_data)
          handled_events.include? event_data
        end
      end
    end
  end
end
