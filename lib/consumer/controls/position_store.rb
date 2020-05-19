module Consumer
  module Controls
    module PositionStore
      def self.example(&block)
        if block.nil?
          cls = Example
        else
          cls = example_class(&block)
        end

        cls.build
      end

      def self.example_class(&block)
        Class.new do
          include ::Consumer::PositionStore

          def self.build
            instance = new
            instance.configure
            instance
          end

          def configure
          end

          class_exec(&block) unless block.nil?
        end
      end

      Example = example_class do
        attr_accessor :telemetry_sink

        def configure
          self.telemetry_sink = ::Consumer::PositionStore::Telemetry::Sink.new

          telemetry.register(telemetry_sink)
        end

        def get
          Position::Global.example
        end

        def put(_)
        end
      end

      module Location
        def self.example
          'somePositionStream'
        end
      end
    end
  end
end
