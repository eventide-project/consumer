require_relative './automated_init'

context "Reader Macro" do
  consumer = Controls::Consumer::Example.build

  read = consumer.read

  context "Read dependency" do
    test "Is instance of class" do
      assert read.instance_of?(Controls::Read::Example)
    end
  end

  context "Subscription" do
    subscription = consumer.subscription

    context "Iterator" do
      iterator = subscription.iterator

      test "Get dependency is set to that of reader" do
        assert iterator.get.equal?(read.get)
      end
    end
  end
end
