require_relative '../../automated_init'

context "Consumer Actor" do
  context "Dispatch Message is Handled" do
    actor = Controls::Actor.example

    current_batch = Controls::MessageData::Batch.example

    oldest_message = current_batch.first or fail

    actor.current_batch = current_batch

    next_message = actor.handle(:dispatch)

    consumer = actor.consumer

    test "Oldest message is dispatched by consumer" do
      assert(consumer) do
        dispatched?(oldest_message)
      end
    end

    test "Dispatched message is removed from current batch" do
      refute(actor.current_batch.include?(oldest_message))
    end

    test "Other messages in current batch are not dispatched" do
      assert(actor.current_batch.size > 1)

      not_dispatched = actor.current_batch.none? do |message|
        consumer.dispatched?(message)
      end

      assert(not_dispatched)
    end

    test "Dispatch message is next for actor" do
      assert(next_message == :dispatch)
    end
  end
end
