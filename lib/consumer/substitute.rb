module Consumer
  module Substitute
    def self.build
      Consumer.new
    end

    class Consumer
      def dispatch(message_data)
        dispatched_messages << message_data
      end

      def dispatched_messages
        @dispatched_messages ||= []
      end

      def dispatched?(message_data=nil, &block)
        if message_data.nil?
          block ||= proc { true }
        else
          block ||= proc { |msg| message_data == msg }
        end

        dispatched_messages.any?(&block)
      end
    end
  end
end
