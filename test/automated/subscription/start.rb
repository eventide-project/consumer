require_relative '../automated_init'

context "Subscription" do
  context "Start Message is Handled" do
    subscription = Controls::Subscription.example

    subscription.handle(:start)

    test "Subscription sends itself next_batch" do
      assert(subscription.send.sent?(:next_batch, address: subscription.address))
    end
  end
end
