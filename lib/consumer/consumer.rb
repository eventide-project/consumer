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

      attr_accessor :poll_interval_milliseconds

      attr_accessor :session

      attr_accessor :supplemental_settings

      dependency :get, MessageStore::Get
      dependency :position_store, PositionStore
      dependency :subscription, Subscription

      virtual :error_raised do |error, message_data|
        raise error
      end

      alias_method :call, :dispatch
    end
  end

  def start(&probe)
    logger.info(tags: [:consumer, :start]) { "Starting consumer: #{self.class.name} (Category: #{category}, Identifier: #{identifier || '(none)'}, Position: #{subscription.position})" }

    if Defaults.startup_info?
      print_info
    end

    log_info
    starting if respond_to?(:starting)

    if not MessageStore::StreamName.category?(category)
      raise Error, "Consumer's stream name must be a category (Stream Name: #{category})"
    end

    _, subscription_thread = ::Actor::Start.(subscription)

    actor_address, actor_thread = Actor.start(self, subscription, include: :thread)

    if probe
      subscription_address = subscription.address

      probe.(self, [actor_thread, subscription_thread], [actor_address, subscription_address])
    end

    logger.info(tags: [:consumer, :start]) { "Started consumer: #{self.class.name} (Category: #{category}, Identifier: #{identifier || '(none)'}, Position: #{subscription.position})" }

    AsyncInvocation::Incorrect
  end

  def print_info
    STDOUT.puts
    STDOUT.puts "    Consumer: #{self.class.name}"
    STDOUT.puts "      Category: #{category}"
    STDOUT.puts "      Position: #{subscription.position}"
    STDOUT.puts "      Identifier: #{identifier || '(none)'}"

    print_startup_info if respond_to?(:print_startup_info)

    STDOUT.puts "      Position Location: #{position_store.location || '(none)'}"

    STDOUT.puts

    STDOUT.puts "      Handlers:"
    self.class.handler_registry.each do |handler|
      STDOUT.puts "        Handler: #{handler.name}"
      STDOUT.puts "          Messages: #{handler.message_registry.message_types.join(', ')}"
    end
  end

  def log_info
    logger.info(tags: [:consumer, :start]) { "Category: #{category} (Consumer: #{self.class.name})" }
    logger.info(tags: [:consumer, :start]) { "Position: #{subscription.position} (Consumer: #{self.class.name})" }
    logger.info(tags: [:consumer, :start]) { "Identifier: #{identifier || 'nil'} (Consumer: #{self.class.name})" }

    log_startup_info if respond_to?(:log_startup_info)

    logger.info(tags: [:consumer, :start]) { "Position Update Interval: #{position_update_interval.inspect} (Consumer: #{self.class.name})" }

    logger.info(tags: [:consumer, :start]) { "Poll Interval Milliseconds: #{poll_interval_milliseconds.inspect} (Consumer: #{self.class.name})" }

    self.class.handler_registry.each do |handler|
      logger.info(tags: [:consumer, :start]) { "Handler: #{handler.name} (Consumer: #{self.class.name})" }
      logger.info(tags: [:consumer, :start]) { "Messages: #{handler.message_registry.message_types.join(', ')} (Handler: #{handler.name}, Consumer: #{self.class.name})" }
    end
  end

  def dispatch(message_data)
    logger.trace(tags: [:consumer, :dispatch, :message]) { "Dispatching message (#{LogText.message_data(message_data)})" }

    self.class.handler_registry.each do |handler|
      handler.(message_data, session: session, settings: supplemental_settings)
    end

    update_position(message_data.global_position)

    logger.debug(tags: [:consumer, :dispatch, :message]) { "Message dispatched (#{LogText.message_data(message_data)})" }
  rescue => error
    logger.error(tag: :*) { "Error raised (Error Class: #{error.class}, Error Message: #{error.message}, #{LogText.message_data(message_data)})" }
    error_raised(error, message_data)
  end

  def update_position(position)
    logger.trace(tags: [:consumer, :position]) { "Updating position (Global Position: #{position}, Counter: #{position_update_counter}/#{position_update_interval})" }

    self.position_update_counter += 1

    if position_update_counter >= position_update_interval
      position_store.put(position)

      logger.debug(tags: [:consumer, :position]) { "Updated position (Global Position: #{position}, Counter: #{position_update_counter}/#{position_update_interval})" }

      self.position_update_counter = 0
    else
      logger.debug(tags: [:consumer, :position]) { "Interval not reached; position not updated (Global Position: #{position}, Counter: #{position_update_counter}/#{position_update_interval})" }
    end
  end

  module LogText
    def self.message_data(message_data)
      "Type: #{message_data.type}, Stream Name: #{message_data.stream_name}, Position: #{message_data.position}, GlobalPosition: #{message_data.global_position}"
    end
  end

  module Configure
    def configure(**kwargs)
      logger.trace(tag: :consumer) { "Configuring (Category: #{category})" }

      super(**kwargs)

      starting_position = self.position_store.get

      Subscription.configure(
        self,
        get,
        position: starting_position,
        poll_interval_milliseconds: poll_interval_milliseconds
      )

      logger.debug(tag: :consumer) { "Done configuring (Category: #{category}, Starting Position: #{starting_position})" }
    end
  end

  module Build
    def build(category, position_update_interval: nil, poll_interval_milliseconds: nil, identifier: nil, supplemental_settings: nil, **arguments)
      instance = new(category)

      if not identifier.nil?
        instance.identifier = identifier
      end

      if not supplemental_settings.nil?
        if not supplemental_settings.is_a?(::Settings)
          supplemental_settings = ::Settings.build(supplemental_settings)
        end

        instance.supplemental_settings = supplemental_settings
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

  module Defaults
    def self.startup_info?
      StartupInfo.get == 'on'
    end

    module StartupInfo
      def self.get
        ENV.fetch(env_var, default)
      end

      def self.env_var
        'STARTUP_INFO'
      end

      def self.default
        'on'
      end
    end
  end
end
