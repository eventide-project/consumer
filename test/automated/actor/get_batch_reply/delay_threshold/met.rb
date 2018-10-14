require_relative '../../../automated_init'

context "Consumer Actor" do
  context "Get Batch Reply Message is Handled" do
    context "Delay Threshhold is Met" do
      actor = Controls::Actor.example

      received_batch = Controls::MessageData::Batch.example

      reply_message = Consumer::Subscription::GetBatch::Reply.new(received_batch)

      actor.delay_threshold = received_batch.size

      next_actor_message = actor.handle(reply_message)

      test "Subscription is sent get batch message" do
        get_batch = Consumer::Subscription::GetBatch.new(actor.address)

        assert(actor.send) do
          sent?(get_batch, address: actor.subscription_address)
        end
      end

      test "Dispatch message is next for actor" do
        assert(next_actor_message == :dispatch)
      end
    end
  end
end
