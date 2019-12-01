module Consumer
  Error = Class.new(RuntimeError)

  def self.included(cls)
    cls.class_exec do
      include Dependency
      include Initializer
      include Virtual
      include Log::Dependency

      extend Build
      extend Start

      extend HandlerMacro
      extend IdentifierMacro

      prepend Configure

      initializer :category

      attr_writer :identifier
      def identifier
        @identifier ||= self.class.identifier
      end

      attr_writer :position_update_interval
      def position_update_interval
        @position_update_interval ||= Defaults.position_update_interval
      end

      attr_writer :position_update_counter
      def position_update_counter
        @position_update_counter ||= 0
      end

      attr_accessor :session

      attr_accessor :poll_interval_milliseconds

      dependency :get
      dependency :position_store, PositionStore
      dependency :subscription, Subscription

      virtual :error_raised do |error, message_data|
        raise error
      end

      alias_method :call, :dispatch
    end
  end

  def dispatch(message_data)
    logger.trace { "Dispatching message (#{LogText.message_data(message_data)})" }

    self.class.handler_registry.each do |handler|
      handler.(message_data, session: session)
    end

    update_position(message_data.global_position)

    logger.info { "Message dispatched (#{LogText.message_data(message_data)})" }

  rescue => error
    logger.error { "Error raised (Error Class: #{error.class}, Error Message: #{error.message}, #{LogText.message_data(message_data)})" }
    error_raised(error, message_data)
  end

  def start(&probe)
    logger.info(tag: :*) { "Starting consumer: #{self.class.name} (Category: #{category}, Identifier: #{identifier || '(none)'}, Position: #{subscription.position})" }

    if not MessageStore::StreamName.category?(category)
      raise Error, "Consumer's stream name must be a category (Stream Name: #{category})"
    end

    starting() if respond_to?(:starting)

    self.class.handler_registry.each do |handler|
      logger.info(tag: :*) { "Handler: #{handler.name} (Category: #{category}, Consumer: #{self.class.name})" }
    end

    _, subscription_thread = ::Actor::Start.(subscription)

    actor_address, actor_thread = Actor.start(self, subscription, include: :thread)

    if probe
      subscription_address = subscription.address

      probe.(self, [actor_thread, subscription_thread], [actor_address, subscription_address])
    end

    logger.info(tag: :*) { "Started consumer: #{self.class.name} (Category: #{category}, Identifier: #{identifier || '(none)'}, Position: #{subscription.position})" }

    AsyncInvocation::Incorrect
  end

  def update_position(position)
    logger.trace { "Updating position (Global Position: #{position}, Counter: #{position_update_counter}/#{position_update_interval})" }

    self.position_update_counter += 1

    if position_update_counter >= position_update_interval
      position_store.put(position)

      logger.debug { "Updated position (Global Position: #{position}, Counter: #{position_update_counter}/#{position_update_interval})" }

      self.position_update_counter = 0
    else
      logger.debug { "Interval not reached; position not updated (Global Position: #{position}, Counter: #{position_update_counter}/#{position_update_interval})" }
    end
  end

  module LogText
    def self.message_data(message_data)
      "Type: #{message_data.type}, Stream Name: #{message_data.stream_name}, Position: #{message_data.position}, GlobalPosition: #{message_data.global_position}"
    end
  end

  module Configure
    def configure(**kwargs)
      logger.trace { "Configuring (Category: #{category})" }

      super(**kwargs)

      starting_position = self.position_store.get

      Subscription.configure(
        self,
        get,
        position: starting_position,
        poll_interval_milliseconds: poll_interval_milliseconds
      )

      logger.debug { "Done configuring (Category: #{category}, Starting Position: #{starting_position})" }
    end
  end

  module Build
    def build(category, position_update_interval: nil, poll_interval_milliseconds: nil, identifier: nil, **arguments)
      instance = new(category)

      unless identifier.nil?
        instance.identifier = identifier
      end

      instance.position_update_interval = position_update_interval
      instance.poll_interval_milliseconds = poll_interval_milliseconds

      instance.configure(**arguments)

      instance
    end
  end

  module Start
    def start(category, **arguments, &probe)
      instance = build category, **arguments
      instance.start(&probe)
    end
  end

  module HandlerMacro
    def handler_macro(handler=nil, &block)
      handler ||= block

      handler_registry.register(handler)
    end
    alias_method :handler, :handler_macro

    def handler_registry
      @handler_registry ||= HandlerRegistry.new
    end
  end

  module IdentifierMacro
    attr_writer :identifier

    def identifier_macro(identifier)
      self.identifier = identifier
    end

    def identifier(identifier=nil)
      if identifier.nil?
        @identifier
      else
        identifier_macro(identifier)
      end
    end
  end
end
