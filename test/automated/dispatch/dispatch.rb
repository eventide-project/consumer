require_relative '../automated_init'

context "Dispatch" do
  handled = []

  handle_1 = proc { |event_data| handled << event_data }
  handle_2 = proc { |event_data| handled << event_data }

  handlers = [handle_1, handle_2]

  dispatch = Consumer::Dispatch.new handlers

  event_data = Controls::EventData.example

  dispatch.(event_data)

  test "Each handler handles event data" do
    assert handled == [event_data, event_data]
  end
end
