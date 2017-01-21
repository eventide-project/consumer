require_relative '../automated_init'

context "Error Handling" do
  context "No error handler" do
    consumer = Controls::Consumer.example

    event_data = Controls::EventData.example

    context "Dispatch fails" do
      error = Controls::Error.example

      consumer.dispatch = proc { raise error }

      test "Error is raised" do
        assert proc { consumer.(event_data) } do
          raises_error? Controls::Error::Example
        end
      end
    end
  end
end
