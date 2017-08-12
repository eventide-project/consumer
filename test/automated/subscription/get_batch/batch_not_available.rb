require_relative '../../automated_init'

context "Subscription" do
  context "Get batch" do
    context "Batch not available" do
      position = Controls::Position::Global.example
      subscription = Controls::Subscription.example(position: position)

      reply_address = Actor::Messaging::Address.new
      get_batch = Consumer::Subscription::GetBatch.new(reply_address)

      subscription.handle(get_batch)

      test "Subscription resends get batch message" do
        assert(subscription.send) do
          sent?(get_batch, address: subscription.address)
        end
      end

      test "Position is unchanged" do
        assert(subscription.position == position)
      end
    end
  end
end
