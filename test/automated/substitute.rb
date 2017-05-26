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
      message_data = Controls::MessageData.example

      substitute.(message_data)

      context "Consumed predicate" do
        context "No argument" do
          test "Returns true" do
            assert substitute.consumed?
          end
        end

        context "Argument" do
          context "Message data matches" do
            test "Returns true" do
              assert substitute.consumed?(message_data)
            end
          end

          context "Message data does not match" do
            other_message_data = Controls::MessageData.example

            test "Returns false" do
              refute substitute.consumed?(other_message_data)
            end
          end
        end

        context "Block" do
          test "Message data is passed" do
            _message_data = nil

            substitute.consumed? do |message_data|
              _message_data = message_data
            end

            assert _message_data.equal?(message_data)
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
