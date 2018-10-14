require_relative '../automated_init'

context "Consumer Actor" do
  context "Receives batch" do
    batch = Controls::MessageData::Batch.example
    reply_message = Consumer::Subscription::GetBatch::Reply.new(batch)

    actor = Controls::Actor.example

    actor.handle(reply_message)

    test "Subscription is sent get batch message" do
      get_batch = Consumer::Subscription::GetBatch.new(actor.address)

      assert(actor.send) do
        sent?(get_batch, address: actor.subscription_address)
      end
    end

    context "Batch" do
      batch.each_with_index do |message_data, index|
        context "Message ##{index + 1}" do
          test "Is dispatched" do
            assert(actor.consumer) do
              dispatched?(message_data)
            end
          end
        end
      end
    end
  end
end
