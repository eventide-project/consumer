require_relative '../automated_init'

context "Handler Registry" do
  context "Register" do
    context "Handler class" do
      handler_class = Controls::Handle::Example

      registry = Consumer::HandlerRegistry.new

      handler = registry.register(handler_class)

      test "Handler is registered" do
        assert(registry.registered?(handler))
      end

      test "Handler class is registered" do
        assert(registry.registered?(handler_class))
      end

      test "Length is increased" do
        assert(registry.count == 1)
      end
    end

    context "Proc" do
      handler = proc { nil }

      registry = Consumer::HandlerRegistry.new

      registry.register(handler)

      test "Handler is registered" do
        assert(registry.registered?(handler))
      end

      test "Proc class is not registered" do
        refute(registry.registered?(Proc))
      end

      test "Length is increased" do
        assert(registry.count == 1)
      end
    end
  end
end
