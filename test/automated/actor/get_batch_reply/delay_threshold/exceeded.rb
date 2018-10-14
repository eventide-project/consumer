require_relative '../../../automated_init'

context "Consumer Actor" do
  context "Get Batch Reply Message is Handled" do
    context "Delay Threshhold Exceeded" do
      actor = Controls::Actor.example

      actor.prefetch_queue = prefetch_queue = Controls::MessageData::Batch.example

      actor.delay_threshold = prefetch_queue.size

      received_batch = Controls::MessageData::Batch.example(instances: 1)
      reply_message = Consumer::Subscription::GetBatch::Reply.new(received_batch)

      actor.handle(reply_message)

      test "Subscription is not sent any message" do
        refute(actor.send) do
          sent?(address: actor.subscription_address)
        end
      end
    end
  end
end
