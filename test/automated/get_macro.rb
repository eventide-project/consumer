require_relative './automated_init'

context "Get Macro" do
  consumer = Controls::Consumer::Example.build

  context "Subscription" do
    subscription = consumer.subscription

    test "Get dependency is instance of class" do
      assert subscription.get.instance_of?(Controls::Get::Example)
    end
  end
end
