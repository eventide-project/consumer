require_relative './automated_init'

context "Optional Settings Argument" do
  stream_name = Controls::StreamName.example

  context "Given" do
    settings = Controls::Session::Settings.example

    consumer = Controls::Consumer::Example.build(stream_name, settings: settings)

    session = consumer.session

    test "Session is configured by given settings" do
      assert(session.settings?(settings))
    end

    test "Instantiated handlers are assigned session" do
      handler, * = consumer.handlers

      assert(handler.session?(session))
    end
  end

  context "Omitted" do
    consumer = Controls::Consumer::Example.build(stream_name)

    session = consumer.session

    test "Session is configured" do
      refute(session.nil?)
    end

    test "Handlers are assigned session" do
      handler, * = consumer.handlers

      assert(handler.session?(session))
    end
  end
end
