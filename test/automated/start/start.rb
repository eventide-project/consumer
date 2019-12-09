require_relative '../automated_init'

context "Consumer" do
  context "Start" do
    return_value = nil
    consumer = nil

    category = Controls::Category.example

    Actor::Supervisor.start do |supervisor|
      return_value = Controls::Consumer::Example.start(category) do |_consumer, _, (consumer_address, subscription_address)|
        consumer = _consumer

        Actor::Messaging::Send.(:stop, consumer_address)
        Actor::Messaging::Send.(:stop, subscription_address)
      end
    end

    test "Returns asynchronous invocation" do
      assert(return_value == AsyncInvocation::Incorrect)
    end

    test "Category is set" do
      assert(consumer.category == category)
    end
  end
end
