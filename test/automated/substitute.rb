require_relative './automated_init'

context "Consumer" do
  context "Substitute" do
    substitute = SubstAttr::Substitute.build Consumer

    context "No events consumed" do
      context "Consumed predicate" do
        test "Returns false" do
          refute substitute.consumed?
        end
      end
    end

    context "Event is consumed" do
      event_data = Controls::EventData.example

      substitute.(event_data)

      context "Consumed predicate" do
        context "No argument" do
          test "Returns true" do
            assert substitute.consumed?
          end
        end

        context "Argument" do
          context "Event data matches" do
            test "Returns true" do
              assert substitute.consumed?(event_data)
            end
          end

          context "Event data does not match" do
            other_event_data = Controls::EventData.example

            test "Returns false" do
              refute substitute.consumed?(other_event_data)
            end
          end
        end

        context "Block" do
          test "Event data is passed" do
            _event_data = nil

            substitute.consumed? do |event_data|
              _event_data = event_data
            end

            assert _event_data.equal?(event_data)
          end

          context "Block returns true" do
            test "Predicate returns true" do
              assert substitute do
                consumed? { true }
              end
            end
          end

          context "Block returns false" do
            test "Predicate returns false" do
              refute substitute do
                consumed? { false }
              end
            end
          end
        end
      end
    end
  end
end
