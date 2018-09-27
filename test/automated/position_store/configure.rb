require_relative '../automated_init'

context "Position Store" do
  context "Configure" do
    context "Attribute name not specified" do
      receiver = OpenStruct.new

      position_store = Controls::PositionStore::Example.configure(receiver)

      test "Set as default attribute name" do
        assert(receiver.position_store == position_store)
      end

      test "Is of class" do
        assert(position_store.instance_of?(Controls::PositionStore::Example))
      end
    end

    context "Attribute name specified" do
      receiver = OpenStruct.new

      position_store = Controls::PositionStore::Example.configure(receiver, attr_name: :some_attr)

      test "Set as specified attribute name" do
        assert(receiver.some_attr == position_store)
      end
    end
  end
end
