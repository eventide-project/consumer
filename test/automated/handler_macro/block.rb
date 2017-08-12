require_relative '../automated_init'

context "Handler Macro" do
  context "Handler is a block" do
    consumer_class = Class.new Controls::Consumer::Example do
      attr_accessor :handled_message

      handler do |message_data|
        self.handled_message = message_data
      end

      def handled?(event)
        handled_message == event
      end
    end

    stream_name = Controls::StreamName.example

    consumer = consumer_class.build(stream_name)

    context "Message is dispatched" do
      message_data = Controls::MessageData.example

      consumer.(message_data)

      test "Message data is dispatched to block" do
        assert(consumer.handled?(message_data))
      end
    end
  end
end
