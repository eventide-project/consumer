module Consumer
  class Subscription
    module Defaults
      def self.poll_interval_milliseconds
        100
      end

      def self.poll_timeout_milliseconds
        0
      end
    end
  end
end
