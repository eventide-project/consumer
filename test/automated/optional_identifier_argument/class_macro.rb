require_relative '../automated_init'

context "Optional Identifier Argument" do
  context "Class Macro Specifies an Identifier" do
    identifier = Controls::Identifier.random

    cls = Controls::Consumer.example_class(identifier: identifier)
    refute(cls.identifier.nil?)

    stream_name = Controls::StreamName.example

    context "Given" do
      given_identifier = Controls::Identifier.random

      consumer = cls.build(stream_name, identifier: given_identifier)

      test "Consumer is assigned given identifier" do
        assert(consumer.identifier == given_identifier)
      end
    end

    context "Omitted" do
      consumer = cls.build(stream_name)

      test "Consumer is assigned identifier given to class macro" do
        assert(consumer.identifier == identifier)
      end
    end
  end
end
