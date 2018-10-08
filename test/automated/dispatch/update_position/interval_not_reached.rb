require_relative '../../automated_init'

context "Dispatch" do
  context "Position update interval not reached" do
    global_position = Controls::Position::Global.example

    consumer = Controls::Consumer.example
    consumer.position_update_interval = 11
    consumer.position_update_counter = 9

    message_data = Controls::MessageData.example(global_position: global_position)

    consumer.dispatch(message_data)

    test "Position is not updated" do
      refute(consumer.position_store) do
        put?
      end
    end
  end
end
