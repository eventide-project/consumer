require_relative '../automated_init'

context "Consumer Actor" do
  context "Receives batch" do
    batch = Controls::EventData::Batch.example
    reply_message = Consumer::Subscription::GetBatch::Reply.new batch

    subscription_address = Actor::Messaging::Address.build
    actor = Consumer::Actor.new subscription_address

    actor.handle reply_message

    test "Subscription is sent get batch message" do
      get_batch = Consumer::Subscription::GetBatch.new actor.address

      assert actor.send do
        sent? get_batch, address: subscription_address
      end
    end

    context "Batch" do
      batch.each_with_index do |event, index|
        context "Event ##{index + 1}" do
          test "Is dispatched" do
            assert actor.consumer do
              consumed? event
            end
          end
        end
      end
    end
  end
end
