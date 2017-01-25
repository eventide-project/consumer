module Consumer
  class Dispatch
    include Log::Dependency

    configure :dispatch

    initializer :handlers

    def self.build(handlers=nil)
      handlers = Array(handlers)

      new handlers
    end

    def call(event_data)
      logger.trace { "Dispatching event (#{LogText.event_data event_data})" }

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
