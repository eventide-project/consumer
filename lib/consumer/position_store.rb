module Consumer
  module PositionStore
    def self.included(cls)
      cls.class_exec do
        include Log::Dependency

        extend Build

        prepend Get
        prepend Put

        initializer :stream

        dependency :telemetry, ::Telemetry
      end
    end

    Virtual::Method.define self, :configure

    module Get
      def self.prepended(cls)
        Virtual::PureMethod.define cls, :get
      end

      def get
        logger.trace { "Get position (Stream: #{stream.name})" }

        position = super

        logger.debug { "Get position done (Stream: #{stream.name}, Position: #{position})" }

        telemetry.record :get, Telemetry::Get.new(position, stream)

        position
      end
    end

    module Put
      def self.prepended(cls)
        Virtual::Method.define cls, :put
      end

      def put(position)
        logger.trace { "Put position (Stream: #{stream.name}, Position: #{position})" }

        super

        logger.debug { "Put position done (Stream: #{stream.name}, Position: #{position})" }

        telemetry.record :put, Telemetry::Put.new(position, stream)

        nil
      end
    end

    module Build
      def build(stream)
        stream = EventSource::Stream.canonize stream

        instance = new stream
        ::Telemetry.configure instance
        instance.configure
        instance
      end
    end
  end
end
