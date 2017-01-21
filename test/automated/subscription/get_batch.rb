require_relative '../automated_init'

context "Subscription" do
  context "Get batch" do
    batch = Controls::EventData::Batch.example
    subscription = Controls::Subscription.example next_batch: batch

    reply_address = Actor::Messaging::Address.new
    get_batch = Consumer::Subscription::GetBatch.new reply_address

    subscription.handle get_batch

    test "Next batch is reset" do
      assert subscription.next_batch == nil
    end

    test "Subscription resends itself resupply message" do
      assert subscription.send do
        sent? :resupply, address: subscription.address
      end
    end

    context "Position" do
      test "Follows the global position of the last event returned" do
        next_position = Controls::Position::Global.example offset: batch.count

        assert subscription.position == next_position
      end
    end
  end
end
