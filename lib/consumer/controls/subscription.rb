module Consumer
  module Controls
    module Subscription
      def self.example(get: nil, batch_size: nil)
        get ||= Get.example(batch_size: batch_size)

        ::Consumer::Subscription.new(get, position)
      end

      def self.get
        Get.example
      end

      def self.position
        Position::Global.example
      end
    end
  end
end
