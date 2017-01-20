module Consumer
  class Subscription
    include Log::Dependency

    configure :subscription

    attr_writer :handlers

    def handlers
      @handlers ||= []
    end

    dependency :iterator, EventSource::Iterator

    def self.build(read)
      instance = new
      instance.iterator = read.iterator
      instance
    end
  end
end
