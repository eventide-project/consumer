require_relative './automated_init'

context "Session" do
  session = :some_session

  stream = Controls::Stream.example

  consumer_class = Class.new do
    include ::Consumer

    attr_accessor :session

    def configure(session: nil)
      self.session = session
    end
  end

  context "Consumer is built" do
    consumer = consumer_class.build stream, session: session

    test "Session is available when consumer is configured" do
      assert consumer.session.equal?(session)
    end
  end
end
