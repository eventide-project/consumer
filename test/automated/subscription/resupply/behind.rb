require_relative '../../automated_init'

context "Subscription" do
  context "Resupply" do
    context "Behind" do
      batch = Controls::MessageData::Batch.example

      position = Controls::Position::Global.example
      subscription = Controls::Subscription.example batch: batch, position: position

      subscription.handle :resupply

      test "Next batch is set" do
        assert subscription.next_batch == batch
      end

      test "Subscription does not send itself a proceeding message" do
        refute subscription.send do
          sent?
        end
      end

      test "Position is not changed" do
        assert subscription.position == position
      end
    end
  end
end
