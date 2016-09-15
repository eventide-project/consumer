require_relative '../bench_init'

context "Cycle message is handled by subscription" do
  stream_name = Controls::Writer.write
  reader = EventStore::Client::HTTP::Reader.build stream_name

  subscription = Subscription.new
  subscription.reader = reader

  next_message = subscription.handle :cycle

  context "Handler proceeds to enqueue the event that has been read" do
    test do
      assert next_message.is_a? Messages::EnqueueEvent
    end

    event_data = next_message.event_data
    control_event_data = Controls::EventData::Read.example

    %i(type data metadata).each do |attribute|
      test "Attribute `#{attribute}' matches" do
        control_attribute = control_event_data.public_send attribute
        attribute = event_data.public_send attribute

        assert attribute == control_attribute
      end
    end
  end
end
