require_relative './automated_init'

context "Position Update Interval" do
  category = Controls::Category.example

  context "Not set" do
    consumer = Controls::Consumer::Example.build(category)

    test "Value is that of default" do
      assert(consumer.position_update_interval == Consumer::Defaults.position_update_interval)
    end
  end

  context "Set" do
    position_update_interval = 11

    consumer = Controls::Consumer::Example.build(category, position_update_interval: position_update_interval)

    test "Value is that specified" do
      assert(consumer.position_update_interval == position_update_interval)
    end
  end
end
