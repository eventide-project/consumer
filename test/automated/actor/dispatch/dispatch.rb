require_relative '../../automated_init'

context "Consumer Actor" do
  context "Dispatch Message is Handled" do
    actor = Controls::Actor.example

    actor.prefetch_queue = prefetch_queue = Controls::MessageData::Batch.example

    oldest_message = prefetch_queue.first or fail

    next_actor_message = actor.handle(:dispatch)

    consumer = actor.consumer

    test "Oldest message is dispatched by consumer" do
      assert(consumer.dispatched?(oldest_message))
    end

    test "Dispatched message is removed from prefetch queue" do
      refute(actor.prefetch_queue.include?(oldest_message))
    end

    test "Other messages in prefetch queue are not dispatched" do
      not_dispatched = actor.prefetch_queue.none? do |message|
        consumer.dispatched?(message)
      end

      assert(not_dispatched)
    end

    test "Dispatch message is next for actor" do
      assert(next_actor_message == :dispatch)
    end
  end
end
