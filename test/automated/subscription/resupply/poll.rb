require_relative '../../automated_init'

context "Subscription" do
  context "Resupply" do
    context "Poll" do
      poll = Controls::Poll.example
      telemetry_sink = Poll.register_telemetry_sink(poll)

      subscription = Controls::Subscription.example
      subscription.poll = poll

      subscription.handle(:resupply)

      test "Poll cycles" do
        assert(telemetry_sink.recorded_cycle?)
      end
    end
  end
end
