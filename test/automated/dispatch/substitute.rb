require_relative '../automated_init'

context "Dispatch" do
  context "Substitute" do
    substitute = SubstAttr::Substitute.build Consumer::Dispatch

    context "No dispatches" do
      context "Dispatched predicate" do
        test "Returns false" do
          refute substitute.dispatched?
        end
      end
    end

    context "Dispatches" do
      event_data = Controls::EventData.example

      substitute.(event_data)

      context "Dispatched predicate" do
        context "No argument" do
          test "Returns true" do
            assert substitute.dispatched?
          end
        end

        context "Argument" do
          context "Event data matches" do
            test "Returns true" do
              assert substitute.dispatched?(event_data)
            end
          end

          context "Event data does not match" do
            other_event_data = Controls::EventData.example

            test "Returns false" do
              refute substitute.dispatched?(other_event_data)
            end
          end
        end

        context "Block" do
          test "Event data is passed" do
            _event_data = nil

            substitute.dispatched? do |event_data|
              _event_data = event_data
            end

            assert _event_data.equal?(event_data)
          end

          context "Block returns true" do
            test "Predicate returns true" do
              assert substitute do
                dispatched? { true }
              end
            end
          end

          context "Block returns false" do
            test "Predicate returns false" do
              refute substitute do
                dispatched? { false }
              end
            end
          end
        end
      end
    end
  end
end
