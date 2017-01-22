require_relative './automated_init'

context "Consumer" do
  context "Start" do
    return_value = nil

    Actor::Supervisor.start do |supervisor|
      return_value = Controls::Consumer::Example.start do |consumer, address|
        Actor::Messaging::Send.(:stop, address)
        Actor::Messaging::Send.(:stop, consumer.subscription.address)
      end
    end

    test "Is asynchronous invocation" do
      assert return_value == AsyncInvocation::Incorrect
    end
  end
end
