require_relative './automated_init'

context "Cycle Configuration" do
  stream_name = Controls::StreamName.example

  context "Not set" do
    consumer = Controls::Consumer::Example.build stream_name

    context "Subscription dependency" do
      subscription = consumer.subscription

      test "Maximum is set to default value" do
        default_maximum = Consumer::Subscription::Defaults.cycle_maximum_milliseconds

        assert subscription.cycle.maximum_milliseconds == default_maximum
      end

      test "Timeout is set to default value" do
        default_timeout = Consumer::Subscription::Defaults.cycle_timeout_milliseconds

        assert subscription.cycle.timeout_milliseconds == default_timeout
      end
    end
  end

  context "Maximum milliseconds" do
    consumer = Controls::Consumer::Example.build stream_name, cycle_maximum_milliseconds: 11

    context "Subscription dependency" do
      subscription = consumer.subscription

      test "Maximum is set on cycle" do
        assert subscription.cycle.maximum_milliseconds == 11
      end
    end
  end

  context "Timeout milliseconds" do
    consumer = Controls::Consumer::Example.build stream_name, cycle_timeout_milliseconds: 11

    context "Subscription dependency" do
      subscription = consumer.subscription

      test "Timeout is set on cycle" do
        assert subscription.cycle.timeout_milliseconds == 11
      end
    end
  end
end
