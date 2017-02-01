module Consumer
  module Controls
    module Consumer
      class Incrementing
        include ::Consumer

        def self.logger
          @logger ||= ::Log.get self
        end

        handler do |event_data|
          logger.info { "Handled event (StreamName: #{event_data.stream_name}, GlobalPosition: #{event_data.global_position})" }
        end

        handler do |event_data|
          logger.debug { event_data.data.pretty_inspect }
        end

        def configure(session: nil, batch_size: nil, position_store: nil)
          sleep_duration = ENV['SLEEP_DURATION'] || 100
          sleep_duration = sleep_duration.to_i

          Get::Incrementing.configure self, sleep_duration

          PositionStore::LocalFile.configure self, position_store: position_store
        end
      end
    end
  end
end
