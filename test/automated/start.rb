require_relative './automated_init'

context "Consumer" do
  context "Start" do
    return_value = nil
    consumer = nil

    stream_name = Controls::StreamName.example

    Actor::Supervisor.start do |supervisor|
      return_value = Controls::Consumer::Example.start stream_name do |_consumer, address|
        consumer = _consumer

        Actor::Messaging::Send.(:stop, address)
        Actor::Messaging::Send.(:stop, consumer.subscription.address)
      end
    end

    test "Is asynchronous invocation" do
      assert return_value == AsyncInvocation::Incorrect
    end

    test "Stream is set" do
      assert consumer.stream.name == stream_name
    end
  end
end
