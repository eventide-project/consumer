require_relative '../automated_init'

context "Supplemental Settings" do
  settings = Controls::Settings.example

  category = Controls::Category.example
  consumer = Controls::Consumer::Settings::Example.build(category, supplemental_settings: settings)

  message_data = Controls::MessageData.example

  context "Message is Dispatched" do
    test "Handler is assigned the supplemental settings" do
      refute_raises(Controls::Handle::Settings::Error) do
        consumer.dispatch(message_data)
      end
    end
  end
end
