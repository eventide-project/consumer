require_relative '../automated_init'

context "Dispatch" do
  message_data = Controls::MessageData.example

  consumer = Controls::Consumer.example

  consumer.dispatch(message_data)

  test "Message is dispatched to each handler" do
    handled_messages = consumer.handled_messages

    assert(handled_messages.count > 1)
  end
end
