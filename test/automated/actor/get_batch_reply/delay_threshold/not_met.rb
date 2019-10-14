require_relative '../../../automated_init'

context "Consumer Actor" do
  context "Get Batch Reply Message is Handled" do
    context "Delay Threshhold Not Met" do
      actor = Controls::Actor.example

      received_batch = Controls::MessageData::Batch.example
      reply_message = Consumer::Subscription::GetBatch::Reply.new(received_batch)

      actor.delay_threshold = received_batch.size + 1

      actor.handle(reply_message)

      test "Subscription is sent get batch message" do
        get_batch = Consumer::Subscription::GetBatch.new(actor.address)

        assert(actor.send.sent?(get_batch, address: actor.subscription_address))
      end
    end
  end
end
