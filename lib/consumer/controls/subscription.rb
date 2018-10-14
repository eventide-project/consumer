module Consumer
  module Controls
    module Subscription
      def self.example(next_batch: nil, batch: nil, position: nil, batch_size: nil)
        stream_name = StreamName.example

        get = Get.example(batch_size: batch_size)

        unless batch.nil?
          get.set_batch(stream_name, batch, position)
        end

        subscription = ::Consumer::Subscription.new(stream_name, get)

        subscription.position = position if position

        unless next_batch.nil?
          subscription.next_batch = next_batch
        end

        subscription
      end
    end
  end
end
