require_relative '../automated_init'

context "Stream Error" do
  context "Consumed Stream is a Stream Rather than a Category" do
    category = Controls::Category.example
    stream_id = Controls::ID.example

    stream_name = Messaging::StreamName.stream_name(stream_id, category)

    test "Is an error" do
      assert_raises Consumer::Error do
        Controls::Consumer::Example.start(stream_name)
      end
    end
  end
end
