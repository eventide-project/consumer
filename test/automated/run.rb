require_relative './automated_init'

context "Consumer" do
  context "Run" do
    consumer = nil
    threads = nil

    stream_name = Controls::StreamName.example

    return_value = Controls::Consumer::Example.run stream_name, cycle_timeout_milliseconds: 1 do |_consumer, _threads|
      consumer = _consumer
      threads = _threads

      raise StopIteration
    end

    test "Is asynchronous invocation" do
      assert return_value == AsyncInvocation::Incorrect
    end

    test "Actors are shutdown" do
      assert threads.map(&:status) == [false, false]
    end
  end
end
