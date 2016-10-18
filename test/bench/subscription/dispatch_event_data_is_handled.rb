require_relative '../bench_init'

context "Dispatch event data is handled by subscription" do
  dispatch_event_data = Controls::Messages::DispatchEventData.example

  context "Buffer is not full" do
    subscription = Subscription.new

    next_message = subscription.handle dispatch_event_data

    test "Cycle message is returned" do
      assert next_message == :cycle
    end
  end

  context "Buffer is full" do
    subscription = Subscription.new
    subscription.queue = Controls::MessageBuffer::Full::Queue.example

    next_message = subscription.handle dispatch_event_data

    test "Dispatch event data message is returned (to be retried)" do
      assert next_message == dispatch_event_data
    end
  end
end
