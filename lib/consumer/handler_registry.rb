module Consumer
  class HandlerRegistry
    Configure.activate(self)

    include Log::Dependency

    configure :handler_registry

    def entries
      @entries ||= Set.new
    end

    def count
      entries.count
    end

    def each(&block)
      entries.each(&block)
    end

    def register(handler)
      logger.trace { "Registering handler (Handler: #{handler.name})" }

      if registered? handler
        error_message = "Handler is already registered (Handler: #{handler.name})"
        logger.error { error_message }
        raise Error, error_message
      end

      entries << handler

      logger.debug { "Handler registered (Handler: #{handler.name})" }

      handler
    end

    def registered?(handler)
      entries.any? do |entry|
        return true if handler == entry 

        next if entry.is_a?(Proc)

        handler === entry
      end
    end

    Error = Class.new(RuntimeError)
  end
end
