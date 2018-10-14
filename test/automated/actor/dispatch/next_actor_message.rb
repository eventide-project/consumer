require_relative '../../automated_init'

context "Consumer Actor" do
  context "Dispatch Message is Handled" do
    context "Next Actor Message" do
      context "Prefetch Queue Is Depleted" do
        actor = Controls::Actor.example

        actor.prefetch_queue = prefetch_queue = Controls::MessageData::Batch.example(instances: 1)

        next_actor_message = actor.handle(:dispatch)

        test "No message is next for actor" do
          assert(next_actor_message.nil?)
        end
      end

      context "Prefetch Queue Is Not Depleted" do
        actor = Controls::Actor.example

        actor.prefetch_queue = prefetch_queue = Controls::MessageData::Batch.example(instances: 2)

        next_actor_message = actor.handle(:dispatch)

        test "Disptach message is next for actor" do
          assert(next_actor_message == :dispatch)
        end
      end
    end
  end
end
