require_relative '../automated_init'

context "Identifier Macro" do
  cls = Class.new do
    include Consumer

    identifier :some_id
  end

  category = Controls::Category.example

  consumer = cls.new(category)

  context "Identifier" do
    identifier = consumer.identifier

    test "Returns value given to macro" do
      assert(identifier == :some_id)
    end
  end
end
