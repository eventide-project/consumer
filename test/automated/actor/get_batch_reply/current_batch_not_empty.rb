require_relative '../../automated_init'

context "Consumer Actor" do
  context "Get Batch Reply Message is Handled" do
    context "Current Batch is Not Empty" do
      actor = Controls::Actor.example

      current_batch = Controls::MessageData::Batch.example
      next_batch = Controls::MessageData::Batch.example

      actor.current_batch = current_batch

      reply_message = Consumer::Subscription::GetBatch::Reply.new(next_batch)

      actor.handle(reply_message)

      test "Next batch is appended to current batch" do
        assert(actor.current_batch == current_batch + next_batch)
      end
    end
  end
end
