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

        def configure_subscription(subscription)
          subscription.get = Get.example
        end
      end
    end
  end
end
