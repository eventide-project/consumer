require_relative '../automated_init'

context "Handler Macro" do
  context "Handler is a class" do
    consumer_class = Controls::Consumer::Example

    stream_name = Controls::StreamName.example

    consumer = consumer_class.build stream_name

    context "Event is dispatched" do
      dispatch = consumer.dispatch

      message_data = Controls::MessageData.example

      dispatch.(message_data)

      test "Event is handled by instance of handler class" do
        handler, * = dispatch.handlers

        assert handler.handled?(message_data)
      end
    end
  end
end
