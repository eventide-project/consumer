require_relative '../automated_init'

context "Consumer Actor" do
  context "Receive Match Message is Handled" do
    actor = Controls::Actor.example

    batch = Controls::MessageData::Batch.example

    reply_message = Consumer::Subscription::GetBatch::Reply.new(batch)

    next_message = actor.handle(reply_message)

    test "Subscription is sent get batch message" do
      get_batch = Consumer::Subscription::GetBatch.new(actor.address)

      assert(actor.send) do
        sent?(get_batch, address: actor.subscription_address)
      end
    end

    test "No message is next for actor" do
      assert(next_message.nil?)
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
