require_relative '../automated_init'

context "Actuator" do
  message_data = Controls::MessageData.example

  consumer = Controls::Consumer.example

  consumer.(message_data)

  test "Message is dispatched to each handler" do
    handled_messages = Controls::Consumer.handled_messages

    assert(handled_messages.count > 1)
  end
end
