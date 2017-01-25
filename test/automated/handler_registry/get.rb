require_relative '../automated_init'

context "Handler Registry" do
  context "Get" do
    consumer = Controls::Consumer.example

    context "Handler class" do
      handler_registry = Consumer::HandlerRegistry.new
      handler_registry.register Controls::Handle::Example

      handle, * = handler_registry.get(consumer)

      test "Handler is instantiated" do
        assert handle.instance_of? Controls::Handle::Example
      end
    end

    context "Proc" do
      handler = proc { self }

      handler_registry = Consumer::HandlerRegistry.new
      handler_registry.register handler

      handle, * = handler_registry.get(consumer)

      test "Handler is evaluated in context of consumer" do
        context = handle.()

        assert context.equal?(consumer)
      end
    end
  end
end
