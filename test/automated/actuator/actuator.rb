require_relative '../automated_init'

context "Actuator" do
  stream_name = Controls::StreamName.example

  message_data = Controls::MessageData.example

  consumer = Controls::Consumer::Example.build(stream_name)

  Controls::Consumer.clear_handled_messages
  consumer.(message_data)

  test "Message is dispatched to each handler" do
    handled_messages = Controls::Consumer.handled_messages(message_data)

    assert(handled_messages.count > 1)
  end
end
