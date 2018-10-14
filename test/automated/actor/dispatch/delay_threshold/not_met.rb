require_relative '../../../automated_init'

context "Consumer Actor" do
  context "Dispatch Message is Handled" do
    context "Delay Threshold Not Met" do
      actor = Controls::Actor.example

      actor.prefetch_queue = prefetch_queue = Controls::MessageData::Batch.example

      actor.delay_threshold = prefetch_queue.size - 2

      actor.handle(:dispatch)

      test "Subscription is not sent any message" do
        refute(actor.send) do
          sent?(address: actor.subscription_address)
        end
      end
    end
  end
end
