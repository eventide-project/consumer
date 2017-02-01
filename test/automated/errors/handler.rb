require_relative '../automated_init'

context "Error Handling" do
  context "Consumer handles errors" do
    consumer_class = Class.new Controls::Consumer::Example do
      attr_accessor :handled_error
      attr_accessor :dispatched_event_data

      def error_raised(error, event_data)
        self.handled_error = error
        self.dispatched_event_data = event_data
      end
    end

    stream_name = Controls::StreamName.example

    consumer = consumer_class.new stream_name

    event_data = Controls::EventData.example

    context "Dispatch fails" do
      error = Controls::Error.example

      consumer.dispatch = proc { raise error }

      test "Error is not raised" do
        refute proc { consumer.(event_data) } do
          raises_error? Controls::Error::Example
        end
      end

      test "Error is passed to error handler" do
        assert consumer.handled_error == error
      end

      test "Event data is passed to error handler" do
        assert consumer.dispatched_event_data == event_data
      end
    end
  end
end
