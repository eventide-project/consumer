module Consumer
  class Actor
    include ::Actor
    include Dependency
    include Initializer
    include Log::Dependency

    initializer :subscription_address, a(:delay_threshold)

    dependency :consumer, Consumer

    attr_writer :prefetch_queue
    def prefetch_queue
      @prefetch_queue ||= []
    end

    def self.build(consumer, subscription)
      subscription_address = subscription.address

      delay_threshold = subscription.batch_size

      instance = new(subscription_address, delay_threshold)
      instance.consumer = consumer
      instance.configure
      instance
    end

    handle :start do
      request_batch
    end

    handle Subscription::GetBatch::Reply do |get_batch_reply|
      received_batch = get_batch_reply.batch

      logger.trace(tag: :actor) { "Received batch (Received Batch Size: #{received_batch.size}, Prefetch Queue Depth: #{prefetch_queue.size}, Delay Threshold: #{delay_threshold})" }

      prefetch_queue_empty = prefetch_queue.empty?

      self.prefetch_queue += received_batch

      unless prefetch_queue.size > delay_threshold
        request_batch
      end

      if prefetch_queue_empty
        next_message = :dispatch
      end

      logger.debug(tag: :actor) { "Batch received (Received Batch Size: #{received_batch.size}, Prefetch Queue Depth: #{prefetch_queue.size}, Delay Threshold: #{delay_threshold}, Next Actor Message: #{next_message || '(none)'})" }

      next_message
    end

    handle :dispatch do
      logger.trace(tag: :actor) { "Dispatching Message (Prefetch Queue Depth: #{prefetch_queue.size}, Delay Threshold: #{delay_threshold})" }

      dispatch_message = prefetch_queue.shift

      if prefetch_queue.size == delay_threshold
        request_batch
      end

      consumer.dispatch(dispatch_message)

      unless prefetch_queue.empty?
        next_message = :dispatch
      end

      logger.debug(tag: :actor) { "Dispatched Message (Prefetch Queue Depth: #{prefetch_queue.size}, Delay Threshold: #{delay_threshold}, Global Position: #{dispatch_message.global_position}, Next Actor Message: #{next_message || '(none)'})" }

      next_message
    end

    def request_batch
      logger.trace(tag: :actor) { "Requesting batch (Prefetch Queue Depth: #{prefetch_queue.size}, Delay Threshold: #{delay_threshold})" }

      get_batch = Subscription::GetBatch.new(address)

      send.(get_batch, subscription_address)

      logger.debug(tag: :actor) { "Sent batch request (Prefetch Queue Depth: #{prefetch_queue.size}, Delay Threshold: #{delay_threshold})" }

      nil
    end
  end
end
