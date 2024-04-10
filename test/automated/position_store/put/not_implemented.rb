require_relative '../../automated_init'

context "Position Store" do
  context "Put not implemented" do
    position_store = Class.new do
      include Consumer::PositionStore
    end

    position_store = position_store.new

    test "Template method error not raised" do
      position = Controls::Position::Global.example

      refute_raises(TemplateMethod::Error) do
        position_store.put(position)
      end
    end
  end
end
