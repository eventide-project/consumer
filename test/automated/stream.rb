require_relative './automated_init'

context "Stream" do
  stream_name = Controls::StreamName.example

  consumer = Controls::Consumer::Example.build stream_name

  context "Subscription dependency" do
    subscription = consumer.subscription

    test "Stream is set" do
      assert subscription.stream.name == stream_name
    end
  end
end
