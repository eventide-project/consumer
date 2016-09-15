require_relative '../bench_init'

context "Enqueue event message is handled by subscription" do
  enqueue_event = Controls::Message::EnqueueEvent.example

  context "Buffer is not full" do
    subscription = Subscription.new

    next_message = subscription.handle enqueue_event

    test "Cycle message is returned" do
      assert next_message == :cycle
    end
  end

  context "Buffer is full" do
    subscription = Subscription.new
    subscription.queue = Controls::MessageBuffer::Full::Queue.example

    next_message = subscription.handle enqueue_event

    test "Enqueue event message is returned (to be retried)" do
      assert next_message == enqueue_event
    end
  end
end
