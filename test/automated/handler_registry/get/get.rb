require_relative '../../automated_init'

context "Handler Registry" do
  context "Get" do
    handler_class = Controls::Handle::Example

    handler_registry = Consumer::HandlerRegistry.new
    handler_registry.register(handler_class)

    handler, * = handler_registry.get

    test "Handler instance is returned" do
      assert(handler.instance_of?(handler_class))
    end
  end
end
