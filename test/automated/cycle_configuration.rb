require_relative './automated_init'

context "Cycle Configuration" do
  context "Maximum milliseconds" do
    consumer = Controls::Consumer::Example.build cycle_maximum_milliseconds: 11

    context "Subscription dependency" do
      subscription = consumer.subscription

      test "Maximum is set on cycle" do
        assert subscription.cycle.maximum_milliseconds == 11
      end
    end
  end

  context "Timeout milliseconds" do
    consumer = Controls::Consumer::Example.build cycle_timeout_milliseconds: 11

    context "Subscription dependency" do
      subscription = consumer.subscription

      test "Timeout is set on cycle" do
        assert subscription.cycle.timeout_milliseconds == 11
      end
    end
  end
end
