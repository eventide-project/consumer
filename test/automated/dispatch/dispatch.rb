require_relative '../automated_init'

context "Dispatch" do
  handled = []

  handle_1 = proc { |event_data| handled << event_data }
  handle_2 = proc { |event_data| handled << event_data }

  dispatch = Consumer::Dispatch.new
  dispatch.handler_registry.register handle_1
  dispatch.handler_registry.register handle_2

  event_data = Controls::EventData.example

  dispatch.(event_data)

  test "Each handler handles event data" do
    assert handled == [event_data, event_data]
  end
end
