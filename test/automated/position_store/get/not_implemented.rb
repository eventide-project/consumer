require_relative '../../automated_init'

context "Position Store" do
  context "Get not implemented" do
    position_store = Class.new do
      include Consumer::PositionStore
    end

    position_store = position_store.new

    test "Abstract method error" do
      assert_raises Virtual::PureMethod::Error do
        position_store.get
      end
    end
  end
end
