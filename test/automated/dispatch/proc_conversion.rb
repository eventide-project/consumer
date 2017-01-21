require_relative '../automated_init'

context "Dispatch" do
  context "Proc conversion" do
    handled = false
    handle = proc { |event_data| handled = true }

    dispatch = Consumer::Dispatch.new
    dispatch.handlers = [handle]

    dispatch_proc = dispatch.to_proc

    context "Proc is called" do
      dispatch_proc.(Controls::EventData.example)

      test "Event data is handled" do
        assert handled
      end
    end
  end
end
