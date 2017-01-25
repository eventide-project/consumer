require_relative '../automated_init'

context "Handler Macro" do
  context "Handler is a class" do
    consumer_class = Controls::Consumer::Example

    stream = Controls::Stream.example

    consumer = consumer_class.build stream

    context "Event is dispatched" do
      dispatch = consumer.dispatch

      event_data = Controls::EventData.example

      dispatch.(event_data)

      test "Event is handled by instance of handler class" do
        handler, * = dispatch.handlers

        assert handler.handled?(event_data)
      end
    end
  end
end
