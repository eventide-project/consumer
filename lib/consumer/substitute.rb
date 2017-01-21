module Consumer
  module Substitute
    def self.build
      Consumer.new
    end

    class Consumer
      def call(event_data)
        consumed_events << event_data
      end

      def consumed_events
        @consumed_events ||= []
      end

      def consumed?(event_data=nil, &block)
        if event_data.nil?
          block ||= proc { true }
        else
          block ||= proc { |e| event_data == e }
        end

        consumed_events.any? &block
      end
    end
  end
end
