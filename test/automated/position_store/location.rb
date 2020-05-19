require_relative '../automated_init'

context "Position Store" do
  context "Location" do
    context "Implemented" do
      location = Controls::PositionStore::Location.example

      position_store = Controls::PositionStore.example do
        attr_accessor :location
      end

      position_store.location = location

      test do
        assert(position_store.location == location)
      end
    end

    context "Not Implemented" do
      position_store = Controls::PositionStore.example

      test do
        assert(position_store.location.nil?)
      end
    end
  end
end
