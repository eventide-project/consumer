require_relative './automated_init'

context "Handler Macro" do
  context "Handler is a class" do
    consumer_class = Class.new do
      include Consumer

      handle Controls::Handle::Example
    end

    context "Consumer" do
      consumer = consumer_class.build

      test "Subscription includes handler" do
        assert consumer.subscription.handlers == [Controls::Handle::Example]
      end
    end
  end

  context "Handler is a block" do
    blk = proc { nil }

    consumer_class = Class.new do
      include Consumer

      handle &blk
    end

    context "Consumer" do
      consumer = consumer_class.build

      test "Subscription includes handler" do
        assert consumer.subscription.handlers == [blk]
      end
    end
  end
end
