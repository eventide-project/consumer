require_relative '../automated_init'

context "Dispatch" do
  dispatch = Consumer::Dispatch.build

  context "Add handler" do
    handler = Controls::Handle.example

    dispatch.add_handler handler

    context "Dispatch event" do
      message_data = Controls::MessageData.example

      dispatch.(message_data)

      test "Handler handles event" do
        assert handler.handled?(message_data)
      end
    end
  end
end
