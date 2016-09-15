require_relative '../bench_init'

context "Incoming messages are written to queue" do
  stream_name = Controls::Writer.write
  reader = EventStore::Client::HTTP::Reader.build stream_name

  subscription = Consumer::Subscription.new
  subscription.reader = reader

  subscription.handle :start
end
