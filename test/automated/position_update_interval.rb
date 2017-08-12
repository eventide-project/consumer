require_relative './automated_init'

context "Position Update Interval" do
  stream_name = Controls::StreamName.example

  context "Not set" do
    consumer = Controls::Consumer::Example.build(stream_name)

    test "Value is that of default" do
      assert(consumer.position_update_interval == Consumer::Defaults.position_update_interval)
    end
  end

  context "Set" do
    position_update_interval = 11

    consumer = Controls::Consumer::Example.build(stream_name, position_update_interval: position_update_interval)

    test "Value is that specified" do
      assert(consumer.position_update_interval == position_update_interval)
    end
  end
end
