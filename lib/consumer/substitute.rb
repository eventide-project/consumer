module Consumer
  module Substitute
    def self.build
      Consumer.new
    end

    class Consumer
      def call(message_data)
        consumed_events << message_data
      end

      def consumed_events
        @consumed_events ||= []
      end

      def consumed?(message_data=nil, &block)
        if message_data.nil?
          block ||= proc { true }
        else
          block ||= proc { |e| message_data == e }
        end

        consumed_events.any? &block
      end
    end
  end
end
