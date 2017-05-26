module Consumer
  def self.included(cls)
    cls.class_exec do
      include Log::Dependency

      extend Build
      extend Run
      extend Start

      extend HandlerMacro

      prepend Configure

      initializer :stream_name

      attr_writer :position_update_interval
      def position_update_interval
        @position_update_interval ||= Defaults.position_update_interval
      end

      attr_accessor :cycle_maximum_milliseconds
      attr_accessor :cycle_timeout_milliseconds

      dependency :dispatch, Dispatch
      dependency :get
      dependency :position_store, PositionStore
      dependency :subscription, Subscription
    end
  end

  def call(message_data)
    logger.trace { "Dispatching event (#{LogText.message_data message_data})" }

    dispatch.(message_data)

    update_position message_data.global_position

    logger.info { "Event dispatched (#{LogText.message_data message_data})" }

  rescue => error
    logger.error { "Error raised (Error Class: #{error.class}, Error Message: #{error.message}, #{LogText.message_data message_data})" }
    error_raised error, message_data
  end

  def run(&probe)
    threads, addresses = nil

    start do |_, _threads, _addresses|
      threads = _threads
      addresses = _addresses
    end

    loop do
      probe.(self, threads, addresses) if probe
      consumer.subscription.cycle { nil }
    end

    addresses.each do |address|
      Actor::Messaging::Send.(:stop, address)
    end

    threads.each &:join

    AsyncInvocation::Incorrect
  end

  def start(&probe)
    _, subscription_thread = ::Actor::Start.(subscription)

    actor_address, actor_thread = Actor.start self, subscription, include: :thread

    if probe
      subscription_address = subscription.address

      probe.(self, [actor_thread, subscription_thread], [actor_address, subscription_address])
    end

    AsyncInvocation::Incorrect
  end

  def add_handler(handler)
    dispatch.add_handler handler
  end

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

  def position_update_interval
    @position_update_interval ||= self.class.position_update_interval
  end

  module LogText
    def self.message_data(message_data)
      "Stream: #{message_data.stream_name}, Position: #{message_data.position}, GlobalPosition: #{message_data.global_position}, Type: #{message_data.type}"
    end
  end

  module Configure
    def configure(batch_size: nil, session: nil, position_store: nil)
      logger.trace { "Configuring (Batch Size: #{batch_size}, Session: #{session.inspect})" }

      super if defined? super

      starting_position = self.position_store.get

      subscription = Subscription.configure(
        self,
        stream_name,
        get,
        position: starting_position,
        cycle_maximum_milliseconds: cycle_maximum_milliseconds,
        cycle_timeout_milliseconds: cycle_timeout_milliseconds
      )

      handlers = self.class.handler_registry.get self

      dispatch = Dispatch.configure self, handlers

      logger.debug { "Done configuring (Batch Size: #{batch_size}, Session: #{session.inspect}, Starting Position: #{starting_position})" }
    end
  end

  module Build
    def build(stream_name, batch_size: nil, position_store: nil, position_update_interval: nil, session: nil, cycle_timeout_milliseconds: nil, cycle_maximum_milliseconds: nil)
      instance = new stream_name
      instance.position_update_interval = position_update_interval
      instance.cycle_maximum_milliseconds = cycle_maximum_milliseconds
      instance.cycle_timeout_milliseconds = cycle_timeout_milliseconds
      instance.configure batch_size: batch_size, position_store: position_store, session: session
      instance
    end
  end

  module Run
    def run(stream_name, **arguments, &probe)
      instance = build stream_name, **arguments
      instance.run &probe
    end
  end

  module Start
    def start(stream_name, **arguments, &probe)
      instance = build stream_name, **arguments
      instance.start &probe
    end
  end

  module HandlerMacro
    def handler_macro(handler=nil, &block)
      handler ||= block

      handler_registry.register handler
    end
    alias_method :handler, :handler_macro

    def handler_registry
      @handler_registry ||= HandlerRegistry.new
    end
  end
end
