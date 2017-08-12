module Consumer
  module Controls
    module Handle
      def self.example
        Example.new
      end

      class Example
        include Messaging::Handle

        def handle(message_data)
          handled_messages << message_data
        end

        def handled_messages
          @handled_messages ||= []
        end

        def handled?(message_data)
          handled_messages.include?(message_data)
        end
      end
    end
  end
end
