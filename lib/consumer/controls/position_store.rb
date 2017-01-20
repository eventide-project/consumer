module Consumer
  module Controls
    module PositionStore
      def self.example
        stream_name = StreamName.example

        Example.build stream_name
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
