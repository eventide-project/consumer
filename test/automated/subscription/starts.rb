require_relative '../automated_init'

context "Subscription" do
  context "Starts" do
    subscription = Controls::Subscription.example

    subscription.handle :start

    test "Subscription sends itself resupply message" do
      assert subscription.send do
        sent? :resupply, address: subscription.address
      end
    end
  end
end
