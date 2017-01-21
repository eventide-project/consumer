module Consumer
  class Subscription
    module Defaults
      def self.cycle_maximum_milliseconds
        100
      end

      def self.cycle_timeout_milliseconds
        1000
      end
    end
  end
end
