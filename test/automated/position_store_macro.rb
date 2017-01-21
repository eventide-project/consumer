require_relative './automated_init'

context "Position Store Macro" do
  context do
    consumer_class = Controls::Consumer::Example

    consumer = consumer_class.build

    position_store = consumer.position_store

    context "Subscription dependency" do
      subscription = consumer.subscription

      test "Iterator offset is set to value in position store" do
        iterator = consumer.subscription.iterator

        assert iterator.stream_offset == Controls::Position::Global.example
      end
    end

    context "Position update interval" do
      update_interval = consumer.position_update_interval

      test "Is set to default value" do
        assert update_interval == Consumer::Defaults.position_update_interval
      end
    end
  end

  context "Position update interval is specified" do
    update_interval = 11

    consumer_class = Class.new Controls::Consumer::Example do
      position_store Controls::PositionStore::Example, update_interval: 11
    end

    consumer = consumer_class.new

    context "Position update interval" do
      test "Is set to default value" do
        assert consumer.position_update_interval == update_interval
      end
    end
  end
end
