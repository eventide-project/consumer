require_relative '../automated_init'

context "Actor" do
  context "Delay Threshold" do
    batch_size = 11

    consumer = Controls::Consumer.example
    subscription = Controls::Subscription.example(batch_size: batch_size)

    actor = Consumer::Actor.build(consumer, subscription)

    test "Set to subscription batch size" do
      assert(actor.delay_threshold == batch_size)
    end
  end
end
