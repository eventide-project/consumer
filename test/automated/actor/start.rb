require_relative '../automated_init'

context "Consumer Actor" do
  context "Start Message is Handled" do
    actor = Controls::Actor.example

    next_actor_message = actor.handle(:start)

    test "Subscription is sent get batch message" do
      get_batch = Consumer::Subscription::GetBatch.new(actor.address)

      assert(actor.send) do
        sent?(get_batch, address: actor.subscription_address)
      end
    end

    test "No message is next for actor" do
      assert(next_actor_message.nil?)
    end
  end
end
