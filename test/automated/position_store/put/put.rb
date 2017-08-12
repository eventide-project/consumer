require_relative '../../automated_init'

context "Position Store" do
  context "Put" do
    position_store = Controls::PositionStore.example

    position = Controls::Position::Global.example
    
    position_store.put(position)

    context "Recorded telemetry" do
      record, * = position_store.telemetry_sink.put_records

      test "Is recorded" do
        refute(record.nil?)
      end

      test "Position" do
        assert(record.data.position == position)
      end
    end
  end
end
