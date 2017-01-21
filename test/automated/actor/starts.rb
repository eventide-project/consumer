require_relative '../automated_init'

context "Consumer Actor" do
  context "Starts" do
    consumer = Controls::Consumer::Example.new
    consumer.subscription_address = Actor::Messaging::Address.build

    consumer.handle :start

    test "Subscription is sent get batch message" do
      get_batch = Consumer::Subscription::GetBatch.new consumer.address

      assert consumer.send do
        sent? get_batch, address: consumer.subscription_address
      end
    end
  end
end
