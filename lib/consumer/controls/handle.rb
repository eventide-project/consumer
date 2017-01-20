module Consumer
  module Controls
    module Handle
      class Example
        include Messaging::Handle

        def handle(event_data)
          handled_events << event_data
        end

        def handled_events
          @handled_events ||= []
        end
      end
    end
  end
end
