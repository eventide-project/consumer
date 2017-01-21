require_relative '../automated_init'

context "Consumer Actor" do
  context "Receives batch" do
    batch = Controls::EventData::Batch.example
    reply_message = Consumer::Subscription::GetBatch::Reply.new batch

    consumer = Controls::Consumer::Example.new
    consumer.subscription_address = Actor::Messaging::Address.build

    consumer.handle reply_message

    test "Subscription is sent get batch message" do
      get_batch = Consumer::Subscription::GetBatch.new consumer.address

      assert consumer.send do
        sent? get_batch, address: consumer.subscription_address
      end
    end

    context "Batch" do
      batch.each_with_index do |event, index|
        context "Event ##{index + 1}" do
          test "Is dispatched" do
            assert consumer.dispatch do
              dispatched? event
            end
          end
        end
      end
    end
  end
end
