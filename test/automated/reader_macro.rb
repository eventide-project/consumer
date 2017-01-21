require_relative './automated_init'

context "Reader Macro" do
  consumer = Controls::Consumer::Example.build

  read = consumer.read

  context "Read dependency" do
    test "Is instance of class" do
      assert read.instance_of?(Controls::Read::Example)
    end
  end

  context "Subscription" do
    subscription = consumer.subscription

    test "Get dependency is set to that of reader" do
      assert subscription.get.equal?(read.get)
    end

    context "Cycle dependency" do
      cycle = subscription.cycle

      test "Maximum milliseconds is set" do
        assert cycle.maximum_milliseconds == Consumer::Defaults.cycle_maximum_milliseconds
      end

      test "Timeout is set" do
        assert cycle.timeout_milliseconds == Consumer::Defaults.cycle_timeout_milliseconds
      end
    end
  end
end
