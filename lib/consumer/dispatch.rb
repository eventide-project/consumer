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
      logger.trace { "Dispatching event (#{LogText.attributes event_data})" }

      handlers = handler_registry.get

      handlers.each do |handle|
        handle.(event_data)
      end

      logger.debug { "Event dispatched (#{LogText.attributes event_data}, Handlers Count: #{handlers.count})" }

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

    module LogText
      def self.attributes(event_data, handlers=nil)
        "Stream: #{event_data.stream_name}, Position: #{event_data.position}, GlobalPosition: #{event_data.global_position}, Type: #{event_data.type}"
      end
    end
  end
end
