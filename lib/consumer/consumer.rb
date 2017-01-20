module Consumer
  def self.included(cls)
    cls.class_exec do
      extend Build

      extend HandleMacro
      extend ReaderMacro
      extend StreamMacro

      prepend Configure

      dependency :subscription, Subscription
      dependency :position_store, PositionStore
      dependency :read
    end
  end

  Virtual::Method.define self, :configure

  module Configure
    def configure
      read = reader_class.configure(
        self,
        stream.name,
        cycle_maximum_milliseconds: Defaults.cycle_maximum_milliseconds,
        cycle_timeout_milliseconds: Defaults.cycle_timeout_milliseconds
      )

      subscription = Subscription.configure(
        self,
        read
      )
      self.class.handler_registry.set subscription
    end
  end

  module Build
    def build
      instance = new
      instance.configure
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

  module ReaderMacro
    def reader_macro(reader_class)
      define_method :reader_class do
        reader_class
      end
    end
    alias_method :reader, :reader_macro
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
