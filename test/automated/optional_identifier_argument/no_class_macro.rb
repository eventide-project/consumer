require_relative '../automated_init'

context "Optional Identifier Argument" do
  context "No Class Macro Specifies an Identifier" do
    cls = Controls::Consumer.example_class(identifier: :none)
    assert(cls.identifier.nil?)

    stream_name = Controls::StreamName.example

    context "Given" do
      identifier = Controls::Identifier.random

      consumer = cls.build(stream_name, identifier: identifier)

      test "Consumer is assigned given identifier" do
        assert(consumer.identifier == identifier)
      end
    end

    context "Omitted" do
      consumer = cls.build(stream_name)

      test "Consumer is not assigned an identifier" do
        assert(consumer.identifier.nil?)
      end
    end
  end
end
