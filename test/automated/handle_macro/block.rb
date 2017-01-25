require_relative '../automated_init'

context "Handler Macro" do
  context "Handler is a block" do
    consumer_class = Class.new Controls::Consumer::Example do
      attr_accessor :handled_event

      handle do |event_data|
        self.handled_event = event_data
      end

      def handled?(event)
        handled_event == event
      end
    end

    stream = Controls::Stream.example

    consumer = consumer_class.build stream

    context "Event is dispatched" do
      event_data = Controls::EventData.example

      consumer.(event_data)

      test "Event data is dispatched to block" do
        assert consumer.handled?(event_data)
      end
    end
  end
end
