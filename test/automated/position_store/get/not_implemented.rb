require_relative '../../automated_init'

context "Position Store" do
  context "Get not implemented" do
    position_store = Class.new do
      include Consumer::PositionStore
    end

    position_store = position_store.new

    test "Abstract method error" do
      assert proc { position_store.get } do
        raises_error? Virtual::PureMethodError
      end
    end
  end
end
