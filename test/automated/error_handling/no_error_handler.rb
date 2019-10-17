require_relative '../automated_init'

context "Error Handling" do
  context "No Error Handler" do
    message_data = Controls::MessageData.example

    context "Dispatch fails" do
      consumer = Controls::Consumer.example(handlers: [
        Controls::Handle::RaiseError::Example
      ])

      test "Error is raised" do
        assert_raises(Controls::Error::Example) do
          consumer.dispatch(message_data)
        end
      end
    end

    context "Dispatch succeeds" do
      consumer = Controls::Consumer.example

      test "Error is not raised" do
        refute_raises(Controls::Error::Example) do
          consumer.dispatch(message_data)
        end
      end
    end
  end
end
