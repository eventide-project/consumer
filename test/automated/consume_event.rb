require_relative './automated_init'

context "Consume Event" do
  event_data = Controls::EventData.example

  consumer = Controls::Consumer.example

  consumer.(event_data)

  test "Event is dispatched" do
    assert consumer.dispatch do
      dispatched? event_data
    end
  end
end
