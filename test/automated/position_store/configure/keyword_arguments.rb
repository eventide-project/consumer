require_relative '../../automated_init'

context "Position Store" do
  context "Configure" do
    context "Keyword Arguments" do
      context "Constructor has keyword parameters" do
        receiver = OpenStruct.new

        position_store_class = Class.new do
          include Consumer::PositionStore
          extend Initializer::Macro

          initializer :some_attribute

          def self.build(some_keyword_parameter:)
            new(some_keyword_parameter)
          end
        end

        position_store_class.configure(receiver, some_keyword_parameter: :some_value)

        position_store = receiver.position_store

        test "Keyword argument is set on instance" do
          assert(position_store.some_attribute == :some_value)
        end
      end

      context "Constructor does not have any keyword parameters" do
        receiver = OpenStruct.new

        position_store_class = Controls::PositionStore::Example

        test "Raises argument error" do
          assert proc { position_store_class.configure(receiver, some_keyword_parameter: :some_value) } do
            raises_error?(ArgumentError)
          end
        end
      end
    end
  end
end
