require_relative '../../../automated_init'

context "Consumer Actor" do
  context "Get Batch Reply Message is Handled" do
    context "Delay Threshhold Exceeded" do
      actor = Controls::Actor.example

      current_batch = Controls::MessageData::Batch.example
      actor.current_batch = current_batch

      actor.delay_threshold = current_batch.size

      batch = Controls::MessageData::Batch.example(instances: 1)
      reply_message = Consumer::Subscription::GetBatch::Reply.new(batch)

      next_message = actor.handle(reply_message)

      test "Subscription is not sent any message" do
        refute(actor.send) do
          sent?(address: actor.subscription_address)
        end
      end

      test "Dispatch message is next for actor" do
        assert(next_message == :dispatch)
      end
    end
  end
end
