require_relative './automated_init'

context "Poll Configuration" do
  category = Controls::Category.example

  context "Not set" do
    consumer = Controls::Consumer::Example.build(category)

    context "Subscription dependency" do
      subscription = consumer.subscription

      test "Interval is set to default value" do
        default_interval = Consumer::Subscription::Defaults.poll_interval_milliseconds

        assert(subscription.poll.interval_milliseconds == default_interval)
      end

      test "Timeout is set to default value" do
        default_timeout = Consumer::Subscription::Defaults.poll_timeout_milliseconds

        assert(subscription.poll.timeout_milliseconds == default_timeout)
      end
    end
  end

  context "Interval milliseconds" do
    consumer = Controls::Consumer::Example.build(category, poll_interval_milliseconds: 11)

    context "Subscription dependency" do
      subscription = consumer.subscription

      test "Interval is set on the poll" do
        assert(subscription.poll.interval_milliseconds == 11)
      end
    end
  end
end
