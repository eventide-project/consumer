require_relative '../../automated_init'

context "Consumer Actor" do
  context "Dispatch Message is Handled" do
    context "Prefetch Queue is Depleted" do
      actor = Controls::Actor.example

      actor.prefetch_queue = prefetch_queue = Controls::MessageData::Batch.example(instances: 1)

      last_message = prefetch_queue.first or fail

      next_actor_message = actor.handle(:dispatch)

      consumer = actor.consumer

      test "Final message of prefetch queue is dispatched by consumer" do
        assert(consumer) do
          dispatched?(last_message)
        end
      end

      test "No message is next for actor" do
        assert(next_actor_message.nil?)
      end
    end
  end
end
