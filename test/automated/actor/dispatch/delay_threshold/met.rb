require_relative '../../../automated_init'

context "Consumer Actor" do
  context "Dispatch Message is Handled" do
    context "Delay Threshold is Met" do
      actor = Controls::Actor.example

      actor.current_batch = current_batch = Controls::MessageData::Batch.example

      actor.delay_threshold = current_batch.size - 1

      actor.handle(:dispatch)

      test "Subscription is sent get batch message" do
        get_batch = Consumer::Subscription::GetBatch.new(actor.address)

        assert(actor.send) do
          sent?(get_batch, address: actor.subscription_address)
        end
      end
    end
  end
end
