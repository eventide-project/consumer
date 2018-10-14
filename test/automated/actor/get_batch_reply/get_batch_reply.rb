require_relative '../../automated_init'

context "Consumer Actor" do
  context "Get Batch Reply Message is Handled" do
    actor = Controls::Actor.example

    batch = Controls::MessageData::Batch.example

    reply_message = Consumer::Subscription::GetBatch::Reply.new(batch)

    next_message = actor.handle(reply_message)

    test "Current batch is set to received batch" do
      assert(actor.current_batch == batch)
    end

    test "Dispatch message is next for actor" do
      assert(next_message == :dispatch)
    end
  end
end
