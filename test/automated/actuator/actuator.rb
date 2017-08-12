require_relative '../automated_init'

context "Actuator" do
  message_data = Controls::MessageData.example

  consumer = Controls::Consumer.example

  consumer.(message_data)

  test "Message is dispatched" do
    assert(consumer.dispatch) do
      dispatched?(message_data)
    end
  end
end
