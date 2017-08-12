require_relative '../../automated_init'

context "Position Store" do
  context "Put" do
    context "Substitute" do
      substitute = SubstAttr::Substitute.build(Consumer::PositionStore)

      context "Position not set" do
        context "Predicate" do
          test "Returns false" do
            refute(substitute.put?)
          end
        end
      end

      context "Position set" do
        position = Controls::Position::Global.example

        substitute.put(position)

        context "Predicate" do
          context "No arguments" do
            test "Returns true" do
              assert(substitute.put?)
            end
          end

          context "Argument matches position" do
            test "Returns true" do
              assert(substitute.put?(position))
            end
          end

          context "Argument does not match position" do
            test "Returns false" do
              refute(substitute.put?(position + 1))
            end
          end
        end
      end
    end
  end
end
