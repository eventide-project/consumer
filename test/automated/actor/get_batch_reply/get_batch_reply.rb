require_relative '../../automated_init'

context "Consumer Actor" do
  context "Get Batch Reply Message is Handled" do
    actor = Controls::Actor.example

    received_batch = Controls::MessageData::Batch.example
    reply_message = Consumer::Subscription::GetBatch::Reply.new(received_batch)

    next_actor_message = actor.handle(reply_message)

    test "Prefetch queue is set to received batch" do
      assert(actor.prefetch_queue == received_batch)
    end

    test "Dispatch message is next for actor" do
      assert(next_actor_message == :dispatch)
    end
  end
end
