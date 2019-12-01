require_relative './automated_init'

context "Optional Settings Argument" do
  category = Controls::Category.example

  context "Given" do
    settings = Controls::Session::Settings.example

    consumer = Controls::Consumer::Example.build(category, settings: settings)

    session = consumer.session

    test "Session is configured by given settings" do
      assert(session.settings?(settings))
    end
  end

  context "Omitted" do
    consumer = Controls::Consumer::Example.build(category)

    session = consumer.session

    test "Session is configured" do
      refute(session.nil?)
    end
  end
end
