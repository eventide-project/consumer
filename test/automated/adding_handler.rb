require_relative './automated_init'

context "Adding Handler" do
  handler = Controls::Handle.example

  consumer = Controls::Consumer.example
  consumer.add_handler handler

  context "Dispatch" do
    dispatch = consumer.dispatch

    test "Handler is added" do
      assert dispatch.handler?(handler)
    end
  end
end
