require_relative '../automated_init'

context "Dispatch" do
  context "Substitute" do
    substitute = SubstAttr::Substitute.build Consumer::Dispatch

    context "No event dispatched" do
      context "Dispatched predicate" do
        test "Returns false" do
          refute substitute.dispatched?
        end
      end
    end

    context "Event dispatched" do
      message_data = Controls::MessageData.example

      substitute.(message_data)

      context "Dispatched predicate" do
        context "No argument" do
          test "Returns true" do
            assert substitute.dispatched?
          end
        end

        context "Argument" do
          context "Message data matches" do
            test "Returns true" do
              assert substitute.dispatched?(message_data)
            end
          end

          context "Message data does not match" do
            other_message_data = Controls::MessageData.example

            test "Returns false" do
              refute substitute.dispatched?(other_message_data)
            end
          end
        end

        context "Block" do
          test "Message data is passed" do
            _message_data = nil

            substitute.dispatched? do |message_data|
              _message_data = message_data
            end

            assert _message_data.equal?(message_data)
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

    context "Add handler" do
      handler = Controls::Handle.example

      substitute.add_handler handler

      test "Predicate returns true" do
        assert substitute.handler?(handler)
      end
    end
  end
end
