require_relative '../../automated_init'

context "Subscription" do
  context "Next Batch" do
    subscription = Controls::Subscription.example

    batch = Controls::MessageData::Batch.example
    subscription.get.items.replace(batch)

    subscription.handle(:next_batch)

    test "Subscription sends itself next_batch" do
      assert(subscription.send.sent?(:next_batch, address: subscription.address))
    end

    context "Consumer" do
      consumer = subscription.consumer

      dispatched_messages = batch.count do |message|
        subscription.consumer.dispatched?(message)
      end
      comment "Dispatched Messages: #{dispatched_messages}"

      messages = batch.size
      detail "Messages in Batch: #{messages}"

      test "All messages dispatched" do
        assert(dispatched_messages == messages)
      end
    end

    context "Position" do
      position = subscription.position
      detail "Position: #{position.inspect}"

      next_position = batch.last.global_position + 1
      detail "Next Position: #{next_position}"

      test "Updated" do
        assert(position == next_position)
      end
    end
  end
end
