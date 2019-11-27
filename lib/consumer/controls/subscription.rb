module Consumer
  module Controls
    module Subscription
## Change stream_name to category
      def self.example(stream_name: nil, next_batch: nil, position: nil, batch_size: nil, count: nil)


## use of stream_name here is the generic meaning of "stream_name"
## Shouldn't need to change
        get = Get.example(stream_name: stream_name, batch_size: batch_size, count: count)

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
