require_relative './automated_init'

context "Stream Macro" do
  context "Category is specified" do
    category = Controls::Stream::Category.example

    consumer_class = Class.new do
      include Consumer
      stream category.name
    end

    consumer = consumer_class.new

    test "Category stream is supplied to instances" do
      assert consumer.stream == category
    end
  end

  context "Stream is specified" do
    stream = Controls::Stream.example

    consumer_class = Class.new do
      include Consumer
      stream stream.name
    end

    consumer = consumer_class.new

    test "Stream is supplied to instances" do
      assert consumer.stream == stream
    end
  end
end
