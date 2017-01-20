module Consumer
  class Subscription
    include Log::Dependency

    configure :subscription

    dependency :iterator, EventSource::Iterator

    def self.build(read)
      instance = new
      instance.iterator = read.iterator
      instance
    end
  end
end
