require_relative '../../automated_init'

context "Position Store" do
  context "Macro" do
    context "Not used" do
      stream = Controls::Stream.example

      consumer_class = Class.new do
        include Consumer
      end

      consumer = consumer_class.build stream

      position_store = consumer.position_store

      context "Subscription dependency" do
        subscription = consumer.subscription

        test "Position is set to 0" do
          assert subscription.position == 0
        end
      end

      context "Position store dependency" do
        test "Is substitute" do
          assert position_store.instance_of?(Consumer::PositionStore::Substitute::PositionStore)
        end
      end
    end
  end
end
