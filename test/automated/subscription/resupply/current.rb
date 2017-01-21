require_relative '../../automated_init'

context "Subscription" do
  context "Resupply" do
    context "Current" do
      position = Controls::Position::Global.example
      subscription = Controls::Subscription.example position: position

      subscription.handle :resupply

      test "Subscription resends itself resupply message" do
        assert subscription.send do
          sent? :resupply, address: subscription.address
        end
      end

      test "Position is not changed" do
        assert subscription.position == position
      end

      test "Next batch is not set" do
        assert subscription.next_batch.nil?
      end
    end
  end
end
