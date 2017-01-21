module Consumer
  module Controls
    module Consumer
      def self.example
        Example.new
      end

      class Example
        include ::Consumer

        handle Handle::Example
        position_store PositionStore::Example
        stream StreamName.example

        cycle maximum_milliseconds: Cycle.maximum_milliseconds, timeout_milliseconds: Cycle.timeout_milliseconds

        def configure_subscription(subscription)
          Get::Example.configure subscription
        end
      end
    end
  end
end
