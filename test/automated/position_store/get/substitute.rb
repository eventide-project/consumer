require_relative '../../automated_init'

context "Position Store" do
  context "Get" do
    context "Substitute" do
      substitute = SubstAttr::Substitute.build Consumer::PositionStore

      context "Position not set" do
        test "Returns nil" do
          assert substitute.get == nil
        end
      end

      context "Position is set" do
        position = Controls::Position::Global.example

        substitute.get_position = position

        test "Returns position" do
          assert substitute.get == position
        end
      end
    end
  end
end
