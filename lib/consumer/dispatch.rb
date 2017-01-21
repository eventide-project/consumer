module Consumer
  class Dispatch
    include Log::Dependency

    configure :dispatch

    attr_writer :handler_registry

    def handler_registry
      @handler_registry ||= HandlerRegistry.new
    end

    def self.build(handler_registry: nil)
      instance = new
      instance.handler_registry = handler_registry unless handler_registry.nil?
      instance
    end

    def call(event_data)
      logger.trace { "Dispatching event (#{LogText.event_data event_data})" }

      handlers = handler_registry.get

      handlers.each do |handle|
        handle.(event_data)
      end

      logger.debug { "Event dispatched (#{LogText.event_data event_data}, Handlers Count: #{handlers.count})" }

      nil
    end

    def to_proc
      method :call
    end

    module Assertions
      def handler?(handle)
        handler_registry.registered? handle
      end
    end
  end
end
