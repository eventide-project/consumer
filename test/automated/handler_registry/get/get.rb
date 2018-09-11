require_relative '../../automated_init'

context "Handler Registry" do
  context "Get" do
    context "Handler class" do
      handler_class = Controls::Handle::Example

      handler_registry = Consumer::HandlerRegistry.new
      handler_registry.register(handler_class)

      handler, * = handler_registry.get

      test "Handler instance is returned" do
        assert(handler.instance_of?(handler_class))
      end
    end

    context "Proc" do
      actuated = false

      control_handler = proc { actuated = true }

      handler_registry = Consumer::HandlerRegistry.new
      handler_registry.register(control_handler)

      handler, * = handler_registry.get

      test "Returns proc that was given" do
        handler.()

        assert(actuated == true)
      end
    end
  end
end
