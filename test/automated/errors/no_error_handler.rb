require_relative '../automated_init'

context "Error Handling" do
  context "No Error Handler" do
    message_data = Controls::MessageData.example

    context "Dispatch fails" do
      consumer = Controls::Consumer.example(handlers: [
        Controls::Handle::Fail::Example
      ])

      test "Error is raised" do
        assert proc { consumer.(message_data) } do
          raises_error? Controls::Error::Example
        end
      end
    end

    context "Dispatch succeeds" do
      consumer = Controls::Consumer.example

      test "Error is not raised" do
        refute proc { consumer.(message_data) } do
          raises_error? Controls::Error::Example
        end
      end
    end
  end
end
