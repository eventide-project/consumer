require_relative './automated_init'

context "Cycle Configuration" do
  stream_name = Controls::StreamName.example

  context "Not set" do
    consumer = Controls::Consumer::Example.build(stream_name)

    context "Subscription dependency" do
      subscription = consumer.subscription

      test "Interval is set to default value" do
        default_interval = Consumer::Subscription::Defaults.cycle_interval_milliseconds

        assert(subscription.cycle.interval_milliseconds == default_interval)
      end

      test "Timeout is set to default value" do
        default_timeout = Consumer::Subscription::Defaults.cycle_timeout_milliseconds

        assert(subscription.cycle.timeout_milliseconds == default_timeout)
      end
    end
  end

  context "Interval milliseconds" do
    consumer = Controls::Consumer::Example.build(stream_name, cycle_interval_milliseconds: 11)

    context "Subscription dependency" do
      subscription = consumer.subscription

      test "Interval is set on cycle" do
        assert(subscription.cycle.interval_milliseconds == 11)
      end
    end
  end

  context "Timeout milliseconds" do
    consumer = Controls::Consumer::Example.build(stream_name, cycle_timeout_milliseconds: 11)

    context "Subscription dependency" do
      subscription = consumer.subscription

      test "Timeout is set on cycle" do
        assert(subscription.cycle.timeout_milliseconds == 11)
      end
    end
  end
end
