module Consumer
  def self.included(cls)
    cls.class_exec do
      extend Build

      extend HandleMacro
      extend ReaderMacro
      extend PositionStoreMacro
      extend StreamMacro

      prepend Configure

      dependency :dispatch, Dispatch
      dependency :position_store, PositionStore
      dependency :subscription, Subscription
      dependency :read
    end
  end

  Virtual::Method.define self, :configure

  module Configure
    def configure
      position_store = position_store_class.configure self, stream

      starting_position = position_store.get

      read = reader_class.configure(
        self,
        stream.name,
        position: starting_position,
        cycle_maximum_milliseconds: Defaults.cycle_maximum_milliseconds,
        cycle_timeout_milliseconds: Defaults.cycle_timeout_milliseconds
      )

      Subscription.configure self, read

      Dispatch.configure(
        self,
        handler_registry: self.class.handler_registry
      )
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

  module PositionStoreMacro
    def position_store_macro(position_store_class)
      define_method :position_store_class do
        position_store_class
      end
    end
    alias_method :position_store, :position_store_macro
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
