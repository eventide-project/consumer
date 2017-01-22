require_relative './automated_init'

context "Handler Macro" do
  consumer_class = Controls::Consumer::Example

  stream = Controls::Stream.example

  context "Handler is a class" do
    context "Consumer" do
      consumer = consumer_class.build stream

      context "Dispatch" do
        dispatch = consumer.dispatch

        test "Dispatcher includes handler" do
          assert dispatch do
            handler? Controls::Handle::Example
          end
        end
      end
    end
  end

  context "Handler is a block" do
    blk = proc { nil }

    consumer_class = Class.new consumer_class do
      handle &blk
    end

    context "Consumer" do
      consumer = consumer_class.build stream

      context "Dispatcher" do
        dispatch = consumer.dispatch

        test "Dispatcher includes handler" do
          assert dispatch do
            handler? blk
          end
        end
      end
    end
  end
end
