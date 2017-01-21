module Consumer
  class Subscription
    include Actor
    include Log::Dependency

    configure :subscription

    initializer :stream

    attr_accessor :next_batch

    attr_writer :position
    def position
      @position ||= 0
    end

    dependency :cycle, Cycle
    dependency :get

    def self.build(stream, get, position: nil, cycle_maximum_milliseconds: nil, cycle_timeout_milliseconds: nil)
      cycle_maximum_milliseconds ||= Defaults.cycle_maximum_milliseconds
      cycle_timeout_milliseconds ||= Defaults.cycle_timeout_milliseconds

      instance = new stream

      instance.get = get
      instance.position = position

      Cycle.configure(
        instance,
        maximum_milliseconds: cycle_maximum_milliseconds,
        timeout_milliseconds: cycle_timeout_milliseconds
      )

      instance
    end

    handle :start do
      :resupply
    end

    handle :resupply do
      batch = cycle.() do
        get.(stream.name, position: position)
      end

      if batch.empty?
        :resupply
      else
        self.next_batch = batch
        nil
      end
    end

    handle :get_batch do |get_batch|
      batch = reset_next_batch

      reply_message = get_batch.reply_message batch

      send.(reply_message, get_batch.reply_address)

      :resupply
    end

    def reset_next_batch
      batch = next_batch

      self.next_batch = nil

      self.position = batch.last.global_position + 1

      batch
    end
  end
end
