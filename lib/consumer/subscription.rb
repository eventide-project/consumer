module Consumer
  class Subscription
    include ::Actor
    include Dependency
    include Initializer
    include Log::Dependency

    initializer :get, a(:position)

    dependency :consumer, Consumer
    dependency :poll, Poll

    attr_writer :prefetch_queue
    def prefetch_queue
      @prefetch_queue ||= []
    end

    def batch_size
      get.batch_size
    end

    def category
      get.category
    end

    def position
      @position ||= 0
    end

    def self.build(consumer, get, position: nil, poll_interval_milliseconds: nil)
      poll_interval_milliseconds ||= Defaults.poll_interval_milliseconds
      poll_timeout_milliseconds = Defaults.poll_timeout_milliseconds

      instance = new(get, position)

      instance.consumer = consumer

      Poll.configure(
        instance,
        interval_milliseconds: poll_interval_milliseconds,
        timeout_milliseconds: poll_timeout_milliseconds
      )

      instance.configure
      instance
    end

    def self.configure(receiver, get, consumer: nil, position: nil, poll_interval_milliseconds: nil, attr_name: nil)
      attr_name ||= :subscription

      consumer ||= receiver

      instance = build(consumer, get, position: position, poll_interval_milliseconds: poll_interval_milliseconds)
      receiver.public_send(:"#{attr_name}=", instance)
      instance
    end

    handle :start do
      :next_batch
    end

    handle :next_batch do
      logger.trace(tag: :actor) { "Getting batch (Position: #{position}, Category: #{category}, Batch Size: #{batch_size})" }

      batch = poll.() do
        get.(position)
      end

      if batch.nil? || batch.empty?
        logger.debug { "No batch retrieved (Position: #{position}, Category: #{category}, Batch Size: #{batch_size})" }
      else
        logger.debug(tag: :actor) { "Batch retrieved (Position: #{position}, Category: #{category}, Batch Size: #{batch_size})" }

        batch.each do |message|
          dispatch(message)
        end
      end

      :next_batch
    end

    def dispatch(message)
      logger.trace(tag: :actor) { "Dispatching message (Position: #{position}, Category: #{category})" }

      consumer.dispatch(message)

      self.position = message.global_position + 1

      logger.debug(tag: :actor) { "Dispatched message (Position: #{position}, Category: #{category})" }
    end
  end
end
