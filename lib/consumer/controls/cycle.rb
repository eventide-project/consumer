module Consumer
  module Controls
    module Cycle
      def self.example
        ::Cycle.build(
          interval_milliseconds: interval_milliseconds,
          timeout_milliseconds: timeout_milliseconds
        )
      end

      def self.interval_milliseconds
        1
      end

      def self.timeout_milliseconds
        11
      end
    end
  end
end
