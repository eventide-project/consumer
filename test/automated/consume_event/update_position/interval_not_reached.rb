require_relative '../../automated_init'

context "Consume Event" do
  context "Position update interval not reached" do
    position = 1

    consumer = Controls::Consumer.example
    consumer.position_update_interval = 2

    event_data = Controls::EventData.example global_position: position

    consumer.(event_data)

    test "Position is not updated" do
      refute consumer.position_store do
        put?
      end
    end
  end
end
