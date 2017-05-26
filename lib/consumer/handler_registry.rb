module Consumer
  class HandlerRegistry
    include Log::Dependency

    configure :handler_registry

    def register(handler)
      logger.trace { "Registering handler (Handler: #{LogText.handler handler})" }

      if registered? handler
        error_message = "Handler is already registered (Handler: #{LogText.handler handler})"
        logger.error error_message
        raise Error, error_message
      end

      entries << handler

      logger.debug { "Handler registered (Handler: #{LogText.handler handler})" }

      handler
    end

    def get(consumer)
      entries.map do |handler|
        if handler.is_a? Proc
          proc { |message_data|
            consumer.instance_exec message_data, &handler
          }
        else
          handler.build
        end
      end
    end

    def registered?(handler)
      entries.any? do |entry|
        return true if handler == entry 

        next if entry.is_a? Proc

        handler === entry
      end
    end

    def entries
      @entries ||= Set.new
    end

    def count
      entries.count
    end

    module LogText
      def self.handler(handler)
        case handler
        when Module then handler.name
        when Proc then '(proc)'
        else handler.inspect
        end
      end
    end

    Error = Class.new StandardError
  end
end
