require_relative '../../../automated_init'

context "Consumer Actor" do
  context "Dispatch Message is Handled" do
    context "Delay Threshold Not Met" do
      actor = Controls::Actor.example

      actor.current_batch = current_batch = Controls::MessageData::Batch.example

      actor.delay_threshold = current_batch.size - 2

      actor.handle(:dispatch)

      test "Subscription is not sent any message" do
        refute(actor.send) do
          sent?(address: actor.subscription_address)
        end
      end
    end
  end
end
