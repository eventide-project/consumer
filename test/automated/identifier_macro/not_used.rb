require_relative '../automated_init'

context "Identifier Macro" do
  context "Not Used" do
    cls = Class.new do
      include Consumer
    end

    category = Controls::Category.example

    consumer = cls.new(category)

    context "Identifier" do
      identifier = consumer.identifier

      test "Returns nil" do
        assert(identifier == nil)
      end
    end
  end
end
