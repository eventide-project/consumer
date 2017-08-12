require_relative '../../automated_init'

context "Subscription" do
  context "Resupply" do
    context "Cycle" do
      cycle = Controls::Cycle.example
      telemetry_sink = Cycle.register_telemetry_sink(cycle)

      subscription = Controls::Subscription.example
      subscription.cycle = cycle

      subscription.handle(:resupply)

      test "Cycle iterates" do
        assert(telemetry_sink.recorded_cycle?)
      end
    end
  end
end
