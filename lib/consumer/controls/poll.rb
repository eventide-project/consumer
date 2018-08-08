module Consumer
  module Controls
    module Poll
      def self.example
        ::Poll.build(
          interval_milliseconds: interval_milliseconds,
          timeout_milliseconds: timeout_milliseconds
        )
      end

      def self.interval_milliseconds
        1
      end

      def self.timeout_milliseconds
        0
      end
    end
  end
end
