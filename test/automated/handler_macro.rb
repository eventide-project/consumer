require_relative './automated_init'

context "Handler Macro" do
  consumer = Controls::Consumer.example

  context "Message is dispatched" do
    message_data = Controls::MessageData.example

    consumer.(message_data)

    test "Message is dispatched to each handler" do
      handled_messages = consumer.handled_messages

      assert(handled_messages.count > 1)
    end
  end
end
