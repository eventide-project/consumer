require_relative './automated_init'

context "Session" do
  session = :some_session

  stream_name = Controls::StreamName.example

  consumer_class = Class.new do
    include ::Consumer

    attr_accessor :session

    def configure(session: nil, **)
      self.session = session
    end
  end

  context "Consumer is built" do
    consumer = consumer_class.build(stream_name, session: session)

    test "Session is available when consumer is configured" do
      assert(consumer.session.equal?(session))
    end
  end
end
