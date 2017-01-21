require_relative './automated_init'

context "Consumer" do
  context "Start" do
    consumer = nil
    address = nil

    return_value = Controls::Consumer::Example.start do |_consumer, _address|
      consumer = _consumer
      address = _address
    end

    Actor::Messaging::Send.(:shutdown, address)
    Actor::Messaging::Send.(:shutdown, consumer.subscription.address)

    test "Is asynchronous invocation" do
      assert return_value == AsyncInvocation::Incorrect
    end
  end
end
