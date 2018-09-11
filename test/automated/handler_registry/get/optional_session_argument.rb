require_relative '../../automated_init'

context "Handler Registry" do
  context "Get" do
    context "Optional Session Argument" do
      handler_class = Controls::Handle::Example

      context "Omitted" do
        handler_registry = Consumer::HandlerRegistry.new
        handler_registry.register(handler_class)

        handler, * = handler_registry.get

        test "No session is configured on handler" do
          refute(handler.session?)
        end
      end

      context "Given" do
        session = Controls::Session.example

        handler_registry = Consumer::HandlerRegistry.new
        handler_registry.register(handler_class)

        handler, * = handler_registry.get(session: session)

        test "No session is configured on handler" do
          assert(handler.session?(session))
        end
      end
    end
  end
end
