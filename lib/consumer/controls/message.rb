module Consumer
  module Controls
    module Message
      def self.example
        EnqueueEvent.example
      end

      module EnqueueEvent
        def self.example
          message = Consumer::Messages::EnqueueEvent.new
          message.event_data = EventData::Read.example
          message
        end
      end
    end
  end
end
