require_relative '../../automated_init'

context "Subscription" do
  context "Next Batch" do
    context "No Messages" do
      subscription = Controls::Subscription.example

      original_position = subscription.position

      subscription.handle(:next_batch)

      test "Subscription sends itself next_batch" do
        assert(subscription.send.sent?(:next_batch, address: subscription.address))
      end

      context "Consumer" do
        consumer = subscription.consumer

        test "No messages dispatched" do
          refute(consumer.dispatched?)
        end
      end

      context "Position" do
        position = subscription.position
        detail "Position: #{position.inspect}"

        detail "Original Position: #{original_position}"

        test "Not changed" do
          assert(position == original_position)
        end
      end
    end
  end
end
