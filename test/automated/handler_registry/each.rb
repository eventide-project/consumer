require_relative '../automated_init'

context "Handler Registry" do
  context "Each" do
    handler = Controls::Handle::Example
    other_handler = Controls::Handle::Alternate::Example

    registry = Consumer::HandlerRegistry.new

    registry.register(handler)
    registry.register(other_handler)

    iterated_handlers = []

    registry.each do |handler|
      iterated_handlers << handler
    end

    test "Iterates over each handler" do
      assert(iterated_handlers == [handler, other_handler])
    end
  end
end
