module Consumer
  module Controls
    module Subscription
      def self.example(category: nil, next_batch: nil, position: nil, batch_size: nil, count: nil)
        get = Get.example(stream_name: category, batch_size: batch_size, count: count)

        subscription = ::Consumer::Subscription.new(get)

        subscription.position = position if position

        unless next_batch.nil?
          subscription.next_batch = next_batch
        end

        subscription
      end
    end
  end
end
