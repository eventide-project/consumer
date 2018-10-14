require_relative '../automated_init'

context "Subscription" do
  context "Batch Size" do
    batch_size = 11

    subscription = Controls::Subscription.example(batch_size: batch_size)

    test "Returns batch size of get dependency" do
      assert(subscription.batch_size == batch_size)
    end
  end
end
