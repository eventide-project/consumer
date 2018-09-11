require_relative './automated_init'

context "Optional Settings Argument" do
  stream_name = Controls::StreamName.example

  context "Given" do
    settings = Controls::Session::Settings.example

    consumer = Controls::Consumer::Example.build(stream_name, settings: settings)

    handler_session = consumer.handler_session

    test "Handler session is configured by given settings" do
      assert(handler_session.settings?(settings))
    end

    test "Instantiated handlers are assigned session" do
      handler, * = consumer.dispatch.handlers

      assert(handler.session?(handler_session))
    end
  end

  context "Omitted" do
    consumer = Controls::Consumer::Example.build(stream_name)

    handler_session = consumer.handler_session

    test "Handler session is configured" do
      assert(handler_session.nil?)
    end

    test "Instantiated handlers are not assigned session" do
      handler, * = consumer.dispatch.handlers

      refute(handler.session?)
    end
  end
end
