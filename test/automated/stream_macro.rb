require_relative './automated_init'

context "Stream macro" do
  context "Category is specified" do
    consumer_class = Class.new do
      include Consumer
      stream Controls::StreamName::Category.example
    end

    consumer = consumer_class.new

    test "Category stream is supplied to instances" do
      assert consumer.stream == Controls::Stream::Category.example
    end
  end

  context "Stream is specified" do
    consumer_class = Class.new do
      include Consumer
      stream Controls::StreamName.example
    end

    consumer = consumer_class.new

    test "Stream is supplied to instances" do
      assert consumer.stream == Controls::Stream.example
    end
  end

  context "Stream is overriden" do
    stream_name = Controls::StreamName.example randomize_category: true

    consumer = Controls::Consumer::Example.new stream_name

    test "Stream is set to the value supplied to constructor" do
      assert consumer.stream.name == stream_name
    end
  end
end
