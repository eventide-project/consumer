require_relative '../automated_init'

context "Handler Registry" do
  context "Get" do
    handler_1 = proc { nil }
    handler_2 = proc { nil }

    handler_registry = Consumer::HandlerRegistry.new
    handler_registry.register handler_1
    handler_registry.register handler_2

    test "Registered handlers are returned" do
      assert handler_registry.get == [handler_1, handler_2]
    end
  end
end
