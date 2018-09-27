require_relative '../automated_init'

context "Actuator" do
  stream_name = Controls::StreamName.example

  message_data = Controls::MessageData.example

  consumer = Controls::Consumer::Example.build(stream_name)
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
