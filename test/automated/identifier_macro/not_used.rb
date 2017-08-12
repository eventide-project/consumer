require_relative '../automated_init'

context "Identifier Macro" do
  context "Not Used" do
    cls = Class.new do
      include Consumer
    end

    stream_name = Controls::StreamName.example

    consumer = cls.new(stream_name)

    context "Identifier" do
      identifier = consumer.identifier

      test "Returns nil" do
        assert(identifier == nil)
      end
    end
  end
end
