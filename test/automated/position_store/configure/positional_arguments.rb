require_relative '../../automated_init'

context "Position Store" do
  context "Configure" do
    context "Positional Arguments" do
      context "Constructor has positional parameters" do
        receiver = OpenStruct.new

        position_store_class = Class.new do
          include Consumer::PositionStore
          include Initializer

          initializer :some_attribute, :other_attribute

          def self.build(some_parameter, other_parameter)
            new(some_parameter, other_parameter)
          end
        end

        position_store_class.configure(receiver, :some_value, :other_value)

        position_store = receiver.position_store

        test "First positional argument is set on instance" do
          assert(position_store.some_attribute == :some_value)
        end

        test "Second positional argument is set on instance" do
          assert(position_store.other_attribute == :other_value)
        end
      end

      context "Constructor does not have any positional parameters" do
        receiver = OpenStruct.new

        position_store_class = Controls::PositionStore::Example

        test "Raises argument error" do
          assert_raises ArgumentError do
            position_store_class.configure(receiver, :some_value)
          end
        end
      end
    end
  end
end
