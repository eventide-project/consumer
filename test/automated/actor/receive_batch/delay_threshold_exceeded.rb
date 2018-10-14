require_relative '../../automated_init'

context "Consumer Actor" do
  context "Receive Match Message is Handled" do
    context "Delay Threshhold Exceeded" do
      actor = Controls::Actor.example

      batch = Controls::MessageData::Batch.example

      reply_message = Consumer::Subscription::GetBatch::Reply.new(batch)

      actor.delay_threshold = batch.size - 1

      next_message = actor.handle(reply_message)

      test "Subscription is not sent any message" do
        refute(actor.send) do
          sent?(address: actor.subscription_address)
        end
      end

      test "No message is next for actor" do
        assert(next_message.nil?)
      end

      context "Batch" do
        batch.each_with_index do |message_data, index|
          context "Message ##{index + 1}" do
            test "Is dispatched" do
              assert(actor.consumer) do
                dispatched?(message_data)
              end
            end
          end
        end
      end
    end
  end
end
