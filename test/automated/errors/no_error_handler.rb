require_relative '../automated_init'

context "Error Handling" do
  context "No error handler" do
    consumer = Controls::Consumer.example

    message_data = Controls::MessageData.example

    context "Dispatch fails" do
      error = Controls::Error.example

      consumer.handlers = [proc { raise error }]

      test "Error is raised" do
        assert proc { consumer.(message_data) } do
          raises_error? Controls::Error::Example
        end
      end
    end
  end
end
