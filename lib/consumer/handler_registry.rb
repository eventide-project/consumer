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

      if handler.respond_to? :build
        instance = handler.build
      else
        instance = handler
      end

      entries << instance

      logger.debug { "Handler registered (Handler: #{LogText.handler handler})" }

      instance
    end

    def get
      entries.to_a
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
