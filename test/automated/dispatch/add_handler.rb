require_relative '../automated_init'

context "Dispatch" do
  dispatch = Consumer::Dispatch.build

  context "Add handler" do
    handler = Controls::Handle.example

    dispatch.add_handler handler

    context "Dispatch event" do
      event_data = Controls::EventData.example

      dispatch.(event_data)

      test "Handler handles event" do
        assert handler.handled?(event_data)
      end
    end
  end
end
