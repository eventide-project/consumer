require_relative '../automated_init'

context "Handler Registry" do
  context "Item already registered" do
    handler_class = Controls::Handle::Example

    registry = Consumer::HandlerRegistry.new

    registry.register(handler_class)

    test "Is error" do
      assert proc { registry.register(handler_class) } do
        raises_error?(Consumer::HandlerRegistry::Error)
      end
    end
  end
end
