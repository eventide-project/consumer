module Consumer
  class Subscription
    include ::Actor
    include Log::Dependency

    configure :subscription

    initializer :stream, :get

    attr_accessor :next_batch

    attr_writer :position
    def position
      @position ||= 0
    end

    dependency :cycle, Cycle

    def self.build(stream, get, position: nil, cycle_maximum_milliseconds: nil, cycle_timeout_milliseconds: nil)
      instance = new stream, get

      instance.position = position

      Cycle.configure(
        instance,
        maximum_milliseconds: cycle_maximum_milliseconds,
        timeout_milliseconds: cycle_timeout_milliseconds
      )

      instance.configure
      instance
    end

    handle :start do
      :resupply
    end

    handle :resupply do
      logger.trace { "Resupplying (StreamName: #{stream.name}, Position: #{position})" }

      batch = cycle.() do
        get.(stream.name, position: position)
      end

      if batch.nil? || batch.empty?
        logger.debug { "Did not resupply; no events available (StreamName: #{stream.name}, Position: #{position})" }

        :resupply
      else
        self.next_batch = batch

        logger.debug { "Resupplied (StreamName: #{stream.name}, Position: #{position}, Batch Size: #{batch.count})" }
      end
    end

    handle :get_batch do |get_batch|
      logger.trace { "Batch request received" }

      if next_batch.nil?
        logger.debug { "Could not fulfill batch request; deferring" }

        return get_batch
      end

      batch = reset_next_batch

      reply_message = get_batch.reply_message batch

      send.(reply_message, get_batch.reply_address)

      logger.debug { "Batch request fulfilled; resupplying (Batch Size: #{batch.count})" }

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
