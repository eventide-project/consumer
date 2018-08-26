module Consumer
  class Dispatch
    include Log::Dependency

    def handlers
      @handlers ||= []
    end

    configure :dispatch

    def self.build(handlers=nil)
      handlers = Array(handlers)

      instance = new

      handlers.each do |handler|
        instance.add_handler(handler)
      end

      instance
    end

    def call(message_data)
      logger.trace { "Dispatching event (#{LogText.message_data(message_data)})" }

      handlers.each do |handle|
        handle.(message_data)
      end

      logger.debug { "Event dispatched (#{LogText.message_data(message_data)}, Handlers Count: #{handlers.count})" }

      nil
    end

    def add_handler(handler)
      handlers << handler
    end

    def to_proc
      method(:call)
    end
  end
end
