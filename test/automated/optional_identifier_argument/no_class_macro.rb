require_relative '../automated_init'

context "Optional Identifier Argument" do
  context "No Class Macro Specifies an Identifier" do
    cls = Controls::Consumer.example_class(identifier: :none)
    assert(cls.identifier.nil?)

    category = Controls::Category.example

    context "Given" do
      identifier = Controls::Identifier.random

      consumer = cls.build(category, identifier: identifier)

      test "Consumer is assigned given identifier" do
        assert(consumer.identifier == identifier)
      end
    end

    context "Omitted" do
      consumer = cls.build(category)

      test "Consumer is not assigned an identifier" do
        assert(consumer.identifier.nil?)
      end
    end
  end
end
