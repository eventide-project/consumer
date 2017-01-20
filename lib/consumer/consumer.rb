module Consumer
  def self.included(cls)
    cls.class_exec do
      extend Build

      extend HandleMacro
      extend StreamMacro

      dependency :subscription, Subscription
      dependency :position_store, PositionStore
    end
  end

  module Build
    def build
      instance = new

      subscription = Subscription.configure instance
      handler_registry.set subscription

      instance
    end
  end

  module HandleMacro
    def handle_macro(handler=nil, &block)
      handler ||= block

      handler_registry.register handler
    end
    alias_method :handle, :handle_macro

    def handler_registry
      @handler_registry ||= HandlerRegistry.new
    end
  end

  module StreamMacro
    def stream_macro(stream_name)
      stream = EventSource::Stream.new stream_name

      define_method :stream do
        stream
      end
    end
    alias_method :stream, :stream_macro
  end
end
