require_relative '../automated_init'

context "Handler Registry" do
  context "Set receiver" do
    handler = Controls::Handle::Example

    registry = Consumer::HandlerRegistry.new
    registry.register handler

    context "Default attribute name" do
      receiver = OpenStruct.new

      registry.set receiver

      test "Handlers are set" do
        assert receiver.handlers == [handler]
      end
    end

    context "Alternate attribute name" do
      receiver = OpenStruct.new

      registry.set receiver, attr_name: :some_attr

      test "Handlers are set" do
        assert receiver.some_attr == [handler]
      end
    end
  end
end
