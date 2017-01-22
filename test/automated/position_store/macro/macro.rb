require_relative '../../automated_init'

context "Position Store" do
  context "Macro" do
    stream = Controls::Stream.example

    consumer_class = Controls::Consumer::Example

    consumer = consumer_class.build stream

    position_store = consumer.position_store

    context "Subscription dependency" do
      subscription = consumer.subscription

      test "Position is set to value in position store" do
        assert subscription.position == Controls::Position::Global.example
      end
    end
  end
end
