module Consumer
  class Subscription
    include ::Actor
    include ::Configure
    include Dependency
    include Initializer
    include Log::Dependency

    configure :subscription

    initializer :get

    attr_accessor :next_batch

    attr_writer :position
    def position
      @position ||= 0
    end

    def batch_size
      get.batch_size
    end

    dependency :poll, Poll

    def self.build(get, position: nil, poll_interval_milliseconds: nil)
      poll_interval_milliseconds ||= Defaults.poll_interval_milliseconds
      poll_timeout_milliseconds = Defaults.poll_timeout_milliseconds

      instance = new(get)

      instance.position = position

      Poll.configure(
        instance,
        interval_milliseconds: poll_interval_milliseconds,
        timeout_milliseconds: poll_timeout_milliseconds
      )

      instance.configure
      instance
    end

    handle :start do
      :resupply
    end

    handle :resupply do
      logger.trace { "Resupplying (Category: #{get.category}, Position: #{position})" }

      batch = poll.() do
        get.(position)
      end

      if batch.nil? || batch.empty?
        logger.debug { "Did not resupply; no events available (Category: #{get.category}, Position: #{position})" }

        :resupply
      else
        self.next_batch = batch

        logger.debug { "Resupplied (Category: #{get.category}, Position: #{position}, Batch Size: #{batch.count})" }
      end
    end

    handle :get_batch do |get_batch|
      logger.trace { "Batch request received" }

      if next_batch.nil?
        logger.debug { "Could not fulfill batch request; deferring" }

        return get_batch
      end

      batch = reset_next_batch

      reply_message = get_batch.reply_message(batch)

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
