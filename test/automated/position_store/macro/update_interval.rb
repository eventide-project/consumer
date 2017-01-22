require_relative '../../automated_init'

context "Position Store" do
  context "Macro" do
    stream = Controls::Stream.example

    context "Update interval not specified" do
      consumer_class = Class.new Controls::Consumer::Example do
        position_store Controls::PositionStore::Example
      end

      consumer = consumer_class.new stream

      context "Position update interval" do
        test "Is set to default value" do
          update_interval = Consumer::Defaults.position_update_interval

          assert consumer.position_update_interval == update_interval
        end
      end
    end

    context "Update interval specified" do
      update_interval = 11

      consumer_class = Class.new Controls::Consumer::Example do
        position_store Controls::PositionStore::Example, update_interval: update_interval
      end

      consumer = consumer_class.new stream

      context "Position update interval" do
        test "Is set" do
          assert consumer.position_update_interval == update_interval
        end
      end
    end
  end
end
