module Consumer
  class Subscription
    module Defaults
      def self.poll_interval_milliseconds
        env_interval = ENV['POLL_INTERVAL_MILLISECONDS']
        return env_interval.to_i if !env_interval.nil?

        100
      end

      def self.poll_timeout_milliseconds
        0
      end
    end
  end
end
