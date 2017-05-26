module Consumer
  module Controls
    module Handle
      def self.example
        Example.new
      end

      class Example
        include Messaging::Handle

        def handle(message_data)
          handled_events << message_data
        end

        def handled_events
          @handled_events ||= []
        end

        def handled?(message_data)
          handled_events.include? message_data
        end
      end
    end
  end
end
