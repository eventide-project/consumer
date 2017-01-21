module Consumer
  module Controls
    module Subscription
      def self.example(next_batch: nil, batch: nil, position: nil)
        stream = Stream.example

        get = Get.example

        unless batch.nil?
          get.set_batch stream.name, batch, position
        end

        subscription = ::Consumer::Subscription.new stream
        subscription.get = get

        subscription.position = position if position

        unless next_batch.nil?
          subscription.next_batch = next_batch
        end

        subscription
      end
    end
  end
end
