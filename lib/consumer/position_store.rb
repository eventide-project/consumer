module Consumer
  module PositionStore
    def self.included(cls)
      cls.class_exec do
        include Dependency
        include TemplateMethod

        include Log::Dependency

        extend Build
        extend ClassConfigure

        prepend Configure
        prepend Get
        prepend Put

        dependency :telemetry, ::Telemetry

        template_method :configure
        template_method :location
      end
    end

    module Build
      def self.extended(cls)
        cls.singleton_class.class_exec do
          include TemplateMethod

          template_method! :build
        end
      end
    end

    module ClassConfigure
      def configure(receiver, *arguments, attr_name: nil, **keyword_arguments)
        attr_name ||= :position_store

        if keyword_arguments.any?
          position_store = build(*arguments, **keyword_arguments)
        else
          position_store = build(*arguments)
        end

        receiver.public_send("#{attr_name}=", position_store)

        position_store
      end
    end

    module Configure
      def configure
        ::Telemetry.configure(self)

        super
      end
    end

    module Get
      def self.prepended(cls)
        cls.class_exec do
          template_method! :get
        end
      end

      def get
        logger.trace(tags: [:position_store, :get]) { "Get position" }

        position = super

        logger.debug(tags: [:position_store, :get]) { "Get position done (Position: #{position || '(none)'})" }

        telemetry.record(:get, Telemetry::Get.new(position))

        position
      end
    end

    module Put
      def self.prepended(cls)
        cls.class_exec do
          template_method :put
        end
      end

      def put(position)
        logger.trace(tags: [:position_store, :put]) { "Put position (Position: #{position})" }

        super

        logger.info(tags: [:position_store, :put]) { "Put position done (Position: #{position})" }

        telemetry.record(:put, Telemetry::Put.new(position))

        nil
      end
    end
  end
end
