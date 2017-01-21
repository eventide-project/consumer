require_relative '../automated_init'

context "Consumer Actor" do
  context "Starts" do
    subscription_address = Actor::Messaging::Address.build
    actor = Consumer::Actor.new subscription_address

    actor.handle :start

    test "Subscription is sent get batch message" do
      get_batch = Consumer::Subscription::GetBatch.new actor.address

      assert actor.send do
        sent? get_batch, address: subscription_address
      end
    end
  end
end
