module Consumer
  class Subscription
    include Log::Dependency

    configure :subscription

    initializer :get, a(:position)

    dependency :cycle, Cycle

    def self.build(read)
      instance = new read.get, read.iterator.position
      Cycle.configure instance, cycle: read.iterator.cycle
      instance
    end
  end
end
