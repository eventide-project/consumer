require_relative './automated_init'

context "Position Store Macro" do
  consumer_class = Controls::Consumer::Example

  context "Consumer" do
    consumer = consumer_class.build

    position_store = consumer.position_store

    context "Subscription dependency" do
      subscription = consumer.subscription

      test "Iterator offset is set to value in position store" do
        iterator = consumer.subscription.iterator

        assert iterator.stream_offset == Controls::Position::Global.example
      end
    end

    context "Dispatcher dependency" do
      dispatcher = consumer.dispatcher

      test "Position store dependency is set" do
        assert dispatcher.position_store == position_store
      end
    end
  end
end
