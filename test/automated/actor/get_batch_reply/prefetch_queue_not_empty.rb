require_relative '../../automated_init'

context "Consumer Actor" do
  context "Get Batch Reply Message is Handled" do
    context "Prefetch Queue is Not Empty" do
      actor = Controls::Actor.example

      actor.prefetch_queue = prefetch_queue = Controls::MessageData::Batch.example

      received_batch = Controls::MessageData::Batch.example
      reply_message = Consumer::Subscription::GetBatch::Reply.new(received_batch)

      next_actor_message = actor.handle(reply_message)

      test "Received batch is appended to prefetch queue" do
        assert(actor.prefetch_queue == prefetch_queue + received_batch)
      end

      test "No message is next for actor" do
        assert(next_actor_message.nil?)
      end
    end
  end
end
