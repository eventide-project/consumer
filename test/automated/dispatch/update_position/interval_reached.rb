require_relative '../../automated_init'

context "Dispatch" do
  context "Position update interval reached" do
    global_position = Controls::Position::Global.example

    context "Counter reaches interval" do
      consumer = Controls::Consumer.example
      consumer.position_update_interval = 11
      consumer.position_update_counter = 10

      message_data = Controls::MessageData.example(global_position: global_position)

      consumer.dispatch(message_data)

      test "Position is updated" do
        assert(consumer.position_store.put?(global_position))
      end

      test "Counter is reset" do
        assert(consumer.position_update_counter == 0)
      end
    end

    context "Counter exceeds interval" do
      consumer = Controls::Consumer.example
      consumer.position_update_interval = 11
      consumer.position_update_counter = 11

      message_data = Controls::MessageData.example(global_position: global_position)

      consumer.dispatch(message_data)

      test "Position is updated" do
        assert(consumer.position_store.put?(global_position))
      end

      test "Counter is reset" do
        assert(consumer.position_update_counter == 0)
      end
    end
  end
end
