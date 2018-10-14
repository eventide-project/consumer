module Consumer
  class Actor
    include ::Actor
    include Dependency
    include Initializer
    include Log::Dependency

    initializer :subscription_address, a(:delay_threshold)

    dependency :consumer, Consumer

    attr_writer :current_batch
    def current_batch
      @current_batch ||= []
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
      next_batch = get_batch_reply.batch

      logger.trace { "Received batch (Next Batch: #{next_batch.size}, Current Batch: #{current_batch.size}, Delay Threshold: #{delay_threshold})" }

      self.current_batch += next_batch

      unless current_batch.size > delay_threshold
        request_batch
      end

      logger.debug { "Batch received (Next Batch: #{next_batch.size}, Current Batch: #{current_batch.size}, Delay Threshold: #{delay_threshold})" }

      :dispatch
    end

    handle :dispatch do
      logger.trace { "Dispatching Message (Current Batch: #{current_batch.size}, Delay Threshold: #{delay_threshold})" }

      dispatch_message = current_batch.shift

      if current_batch.size == delay_threshold
        request_batch
      end

      consumer.dispatch(dispatch_message)

      unless current_batch.empty?
        next_message = :dispatch
      end

      logger.debug { "Dispatched Message (Current Batch: #{current_batch.size}, Delay Threshold: #{delay_threshold}, Next Message: #{next_message.inspect})" }

      next_message
    end

    def request_batch
      logger.trace { "Requesting batch" }

      get_batch = Subscription::GetBatch.new(address)

      send.(get_batch, subscription_address)

      logger.debug { "Send batch request" }

      nil
    end
  end
end
