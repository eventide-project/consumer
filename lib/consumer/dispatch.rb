module Consumer
  class Dispatch
    include Log::Dependency

    configure :dispatch

    initializer :handler_registry

    def self.build(handler_registry)
      new handler_registry
    end

    def call(event_data)
      logger.trace { "Dispatching event (#{LogText.attributes event_data, handlers})" }

      handlers.each do |handler|
        handler.(event_data)
      end

      logger.debug { "Event dispatched (#{LogText.attributes event_data, handlers})" }

      nil
    end

    def to_proc
      method :call
    end

    module Assertions
      def handler?(handle)
        handlers.include? handle
      end
    end

    module LogText
      def self.attributes(event_data, handlers)
        "Stream: #{event_data.stream_name}, Position: #{event_data.position}, GlobalPosition: #{event_data.global_position}, Type: #{event_data.type}, Handler Count: #{handlers.count}"
      end
    end
  end
end
