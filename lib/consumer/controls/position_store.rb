module Consumer
  module Controls
    module PositionStore
      def self.example
        Example.build
      end

      class Example
        include ::Consumer::PositionStore

        attr_accessor :telemetry_sink

        def configure
          self.telemetry_sink = ::Consumer::PositionStore::Telemetry::Sink.new

          telemetry.register telemetry_sink
        end

        def get
          Position::Global.example
        end

        def put(_)
        end
      end
    end
  end
end
