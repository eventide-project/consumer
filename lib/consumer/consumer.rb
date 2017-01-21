module Consumer
  def self.included(cls)
    cls.class_exec do
      include Log::Dependency

      extend Build
      extend Start

      extend CycleMacro
      extend HandleMacro
      extend PositionStoreMacro
      extend StreamMacro

      prepend Configure

      attr_writer :position_update_interval

      dependency :dispatch, Dispatch
      dependency :get
      dependency :position_store, PositionStore
      dependency :subscription, Subscription
    end
  end

  def call(event_data)
    logger.trace { "Dispatching event (#{LogText.event_data event_data})" }

    dispatch.(event_data)

    update_position event_data.global_position

    logger.info { "Event dispatched (#{LogText.event_data event_data})" }

  rescue => error
    logger.error { "Error raised (Error Class: #{error.class}, Error Message: #{error.message}, #{LogText.event_data event_data})" }
    error_raised error, event_data
  end

  Virtual::Method.define self, :configure

  def error_raised(error, _)
    raise error
  end

  def update_position(position)
    logger.trace { "Updating position (Position: #{position}, Interval: #{position_update_interval})" }

    if position % position_update_interval == 0
      position_store.put position

      logger.debug { "Updated position (Position: #{position}, Interval: #{position_update_interval})" }
    else
      logger.debug { "Interval not reached; position not updated (Position: #{position}, Interval: #{position_update_interval})" }
    end
  end

  module LogText
    def self.event_data(event_data)
      "Stream: #{event_data.stream_name}, Position: #{event_data.position}, GlobalPosition: #{event_data.global_position}, Type: #{event_data.type}"
    end
  end

  module Configure
    def configure
      super

      position_store = position_store_class.configure self, stream

      starting_position = position_store.get

      subscription = Subscription.configure(
        self,
        stream,
        get,
        position: starting_position,
        cycle_maximum_milliseconds: self.class.cycle_maximum_milliseconds,
        cycle_timeout_milliseconds: self.class.cycle_timeout_milliseconds
      )

      Dispatch.configure self, handler_registry: self.class.handler_registry
    end
  end

  module Build
    def build
      instance = new
      instance.configure
      instance
    end
  end

  module Start
    def start(&probe)
      instance = build

      _, subscription_thread = ::Actor::Start.(instance.subscription)

      actor_address = Actor.start instance, instance.subscription

      probe.(instance, actor_address) if probe

      AsyncInvocation::Incorrect
    end
  end

  module CycleMacro
    def self.extended(cls)
      cls.singleton_class.class_exec do
        attr_accessor :cycle_maximum_milliseconds
        attr_accessor :cycle_timeout_milliseconds
      end
    end

    def cycle_macro(maximum_milliseconds: nil, timeout_milliseconds: nil)
      self.cycle_maximum_milliseconds = maximum_milliseconds
      self.cycle_timeout_milliseconds = timeout_milliseconds
    end
    alias_method :cycle, :cycle_macro
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
    def position_store_macro(position_store_class, update_interval: nil)
      update_interval ||= Defaults.position_update_interval

      define_method :position_store_class do
        position_store_class
      end

      define_method :position_update_interval do
        @position_update_interval ||= update_interval
      end
    end
    alias_method :position_store, :position_store_macro
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
