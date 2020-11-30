require_relative '../automated_init'

context "Supplemental Settings" do
  context "Data Source Argument" do
    settings_data = Controls::Settings.data

    handler_class = Controls::Handle::Settings.example_class do
      define_method :handle do |_message_data|
        settings = ::Settings.build(settings_data)

        assigned_settings = settings?(settings)

        self.class.assigned_settings = assigned_settings
      end

      class << self
        attr_accessor :assigned_settings

        def assigned_settings?
          assigned_settings ? true : false
        end
      end
    end

    consumer_class = Controls::Consumer.example_class(handlers: [handler_class])

    category = Controls::Category.example
    consumer = consumer_class.build(category, supplemental_settings: settings_data)

    message_data = Controls::MessageData.example

    context "Message is Dispatched" do
      consumer.dispatch(message_data)

      test "Handler is assigned the settings from the data source" do
        assert(handler_class.assigned_settings?)
      end
    end
  end
end
