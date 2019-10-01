require_relative '../../automated_init'

context "Subscription" do
  context "Resupply" do
    context "Behind" do
      position = Controls::Position::Global.example
      subscription = Controls::Subscription.example(position: position, count: position + 1)

      batch = subscription.get.items[position..-1]

      subscription.handle(:resupply)

      test "Next batch is set" do
        assert(subscription.next_batch == batch)
      end

      test "Subscription does not send itself a proceeding message" do
        refute(subscription.send) do
          sent?
        end
      end

      test "Position is not changed" do
        assert(subscription.position == position)
      end
    end
  end
end
