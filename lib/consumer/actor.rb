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
      messages = get_batch_reply.batch

      logger.trace { "Received batch (Messages: #{messages.count})" }

      unless messages.count > delay_threshold
        request_batch
      end

      messages.each do |message_data|
        consumer.dispatch(message_data)
      end

      logger.debug { "Batch received (Events: #{messages.count})" }
    end

    def request_batch
      logger.trace { "Requesting batch" }

      get_batch = Subscription::GetBatch.new(address)

      send.(get_batch, subscription_address)

      logger.debug { "Send batch request" }
    end
  end
end
