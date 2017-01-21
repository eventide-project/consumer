require_relative '../../automated_init'

context "Consume Event" do
  context "Position update interval reached" do
    position = 4

    context "Precise match" do
      consumer = Controls::Consumer.example
      consumer.position_update_interval = position

      event_data = Controls::EventData.example global_position: position

      consumer.(event_data)

      test "Position is updated" do
        assert consumer.position_store do
          put? position
        end
      end
    end

    context "Position is multiple of interval" do
      consumer = Controls::Consumer.example
      consumer.position_update_interval = position / 2

      event_data = Controls::EventData.example global_position: position

      consumer.(event_data)

      test "Position is updated" do
        assert consumer.position_store do
          put? position
        end
      end
    end
  end
end
