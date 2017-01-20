module Consumer
  class HandlerRegistry
    include Log::Dependency

    def register(handler)
      logger.trace { "Registering handler (Handler: #{LogText.handler handler})" }

      if registered? handler
        error_message = "Handler is already registered (Handler: #{LogText.handler handler})"
        logger.error error_message
        raise Error, error_message
      end

      entries << handler

      logger.debug { "Handler registered (Handler: #{LogText.handler handler})" }

      entries
    end

    def registered?(handler)
      entries.include? handler
    end

    def set(receiver, attr_name: nil)
      attr_name ||= :handlers

      handlers = entries.to_a

      receiver.public_send "#{attr_name}=", handlers

      handlers
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
