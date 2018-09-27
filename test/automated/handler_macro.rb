require_relative './automated_init'

context "Handler Macro" do
  consumer_class = Controls::Consumer::Example

  stream_name = Controls::StreamName.example

  consumer = consumer_class.build(stream_name)

  context "Message is dispatched" do
    message_data = Controls::MessageData.example

    handlers = consumer.handlers
    assert(handlers.count > 1)

    consumer.(message_data)

    test "Message is dispatched to each handler" do
      dispatched = handlers.all? do |handler|
        handler.handled?(message_data)
      end

      assert(dispatched)
    end
  end
end
