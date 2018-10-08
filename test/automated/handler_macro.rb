require_relative './automated_init'

context "Handler Macro" do
  consumer = Controls::Consumer.example

  context "Message is dispatched" do
    message_data = Controls::MessageData.example

    Controls::Consumer.clear_handled_messages
    consumer.(message_data)

    test "Message is dispatched to each handler" do
      handled_messages = Controls::Consumer.handled_messages(message_data)

      assert(handled_messages.count > 1)
    end
  end
end
