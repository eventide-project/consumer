require_relative '../../automated_init'

context "Consumer Actor" do
  context "Dispatch Message is Handled" do
    context "Current Batch is Depleted" do
      actor = Controls::Actor.example

      current_batch = Controls::MessageData::Batch.example(instances: 1)

      last_message = current_batch.first or fail

      actor.current_batch = current_batch

      next_message = actor.handle(:dispatch)

      consumer = actor.consumer

      test "Last message of batch is dispatched by consumer" do
        assert(consumer) do
          dispatched?(last_message)
        end
      end

      test "No message is next for actor" do
        assert(next_message.nil?)
      end
    end
  end
end
