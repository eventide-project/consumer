require_relative '../bench_init'

context "Cycle message is handled by subscription" do
  stream_name = Controls::Writer.write
  reader = EventStore::Client::HTTP::Reader.build stream_name

  subscription = Subscription.new
  subscription.reader = reader

  next_message = subscription.handle :cycle

  context "Handler enqueues a DispatchEventData message" do
    control_message = Controls::Messages::DispatchEventData.example

    test "Message type" do
      assert next_message.instance_of?(control_message.class)
    end
  end
end
