require_relative '../../automated_init'

context "Position Store" do
  context "Get" do
    position_store = Controls::PositionStore.example

    position = position_store.get

    test "Position is returned" do
      assert position == Controls::Position::Global.example
    end

    context "Recorded telemetry" do
      record, * = position_store.telemetry_sink.get_records

      test "Is recorded" do
        refute record.nil?
      end

      test "Position" do
        assert record.data.position == position
      end
    end
  end
end
