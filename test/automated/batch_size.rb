require_relative './automated_init'

context "Batch Size" do
  batch_size = 11

  stream = Controls::Stream.example

  consumer_class = Class.new do
    include ::Consumer

    attr_accessor :batch_size

    def configure(batch_size: nil, **)
      self.batch_size = batch_size
    end
  end

  context "Consumer is built" do
    consumer = consumer_class.build stream, batch_size: batch_size

    test "Batch size is available when consumer is configured" do
      assert consumer.batch_size == batch_size
    end
  end
end
