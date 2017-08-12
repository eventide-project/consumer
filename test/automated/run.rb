require_relative './automated_init'

context "Consumer" do
  context "Run" do
    threads = nil

    stream_name = Controls::StreamName.example

    return_value = Controls::Consumer::Example.run(stream_name, cycle_timeout_milliseconds: 1) do |_, _threads|
      threads = _threads

      raise StopIteration
    end

    test "Returns asynchronous invocation" do
      assert(return_value == AsyncInvocation::Incorrect)
    end

    test "Actors are shut down" do
      assert(threads.map(&:status) == [false, false])
    end
  end
end
