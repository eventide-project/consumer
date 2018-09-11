require_relative '../../automated_init'

context "Handler Registry" do
  context "Get" do
    context "Optional Context Argument" do
      control_handler = proc { self }

      context "Omitted" do
        control_context = self

        handler_registry = Consumer::HandlerRegistry.new
        handler_registry.register(control_handler)

        handler, * = handler_registry.get

        test "Block form handlers are evaluated their original context" do
          context = handler.()

          assert(context == control_context)
        end
      end

      context "Given" do
        control_context = Object.new

        handler_registry = Consumer::HandlerRegistry.new
        handler_registry.register(control_handler)

        handler, * = handler_registry.get(context: control_context)

        test "Block form handlers are evaluated the given context" do
          context = handler.()

          assert(context == control_context)
        end
      end
    end
  end
end
