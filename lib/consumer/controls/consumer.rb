module Consumer
  module Controls
    module Consumer
      def self.example
        Example.new
      end

      class Example
        include ::Consumer

        handle Handle::Example
        position_store PositionStore::Example
        stream StreamName.example
        cycle maximum_milliseconds: Cycle.maximum_milliseconds, timeout_milliseconds: Cycle.timeout_milliseconds

        def configure
          Get::Example.configure self
        end
      end

      class Incrementing
        include ::Consumer

        handle do |event_data|
          logger = ::Log.get self

          logger.info { "Handled event (StreamName: #{event_data.stream_name}, GlobalPosition: #{event_data.global_position})" }
          logger.debug { event_data.data.pretty_inspect }
        end

        position_store PositionStore::LocalFile, update_interval: 10
        stream StreamName.example

        def configure
          sleep_duration = ENV['SLEEP_DURATION'] || 100
          sleep_duration = sleep_duration.to_i

          Get::Incrementing.configure self, sleep_duration
        end
      end
    end
  end
end
