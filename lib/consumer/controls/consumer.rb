module Consumer
  module Controls
    module Consumer
      def self.example
        Example.new Stream.example
      end

      class Example
        include ::Consumer

        handle Handle::Example
        position_store PositionStore::Example

        def configure
          Get::Example.configure self
        end
      end

      class Incrementing
        include ::Consumer

        def self.logger
          @logger ||= ::Log.get self
        end

        handle do |event_data|
          logger.info { "Handled event (StreamName: #{event_data.stream_name}, GlobalPosition: #{event_data.global_position})" }
        end

        handle do |event_data|
          logger.debug { event_data.data.pretty_inspect }
        end

        position_store PositionStore::LocalFile, update_interval: 10

        def configure
          sleep_duration = ENV['SLEEP_DURATION'] || 100
          sleep_duration = sleep_duration.to_i

          Get::Incrementing.configure self, sleep_duration
        end
      end
    end
  end
end
