require_relative '../automated_init'

context "Handler Registry" do
  context "Register" do
    handler = Controls::Handle::Example

    registry = Consumer::HandlerRegistry.new

    registry.register handler

    test "Handler is registered" do
      assert registry.registered?(handler)
    end

    test "Length is increased" do
      assert registry.count == 1
    end
  end
end
