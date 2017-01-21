require_relative './automated_init'

context "Cycle Macro" do
  context "Maximum milliseconds" do
    consumer_class = Class.new Controls::Consumer::Example do
      cycle maximum_milliseconds: 11
    end

    consumer = consumer_class.build

    context "Subscription dependency" do
      subscription = consumer.subscription

      test "Timeout is set on cycle" do
        assert subscription.cycle.maximum_milliseconds == 11
      end
    end
  end

  context "Timeout milliseconds" do
    consumer_class = Class.new Controls::Consumer::Example do
      cycle timeout_milliseconds: 11
    end

    consumer = consumer_class.build

    context "Subscription dependency" do
      subscription = consumer.subscription

      test "Timeout is set on cycle" do
        assert subscription.cycle.timeout_milliseconds == 11
      end
    end
  end
end
