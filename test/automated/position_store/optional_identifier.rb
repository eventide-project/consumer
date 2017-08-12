require_relative '../automated_init'

context "Position Store" do
  context "Optional Identifier" do
    cls = Class.new do
      include Consumer::PositionStore

      attr_accessor :configured_identifier

      def configure
        self.configured_identifier = self.identifier
      end
    end

    context "Identifier Is Given" do
      identifier = Controls::Identifier.example

      position_store = cls.build(identifier)

      test "Identifier is available during configuration" do
        assert(position_store.configured_identifier == identifier)
      end
    end

    context "Not Given" do
      position_store = cls.build

      test "Identifier is nil during configuration" do
        assert(position_store.configured_identifier == nil)
      end
    end
  end
end
