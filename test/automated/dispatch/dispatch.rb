require_relative '../automated_init'

context "Dispatch" do
  handled = []

  handle_1 = proc { |message_data| handled << message_data }
  handle_2 = proc { |message_data| handled << message_data }

  handlers = [handle_1, handle_2]

  dispatch = Consumer::Dispatch.build(handlers)

  message_data = Controls::MessageData.example

  dispatch.(message_data)

  test "Each handler handles message data" do
    assert(handled == [message_data, message_data])
  end
end
