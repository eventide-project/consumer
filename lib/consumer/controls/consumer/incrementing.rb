module Consumer
  module Controls
    module Consumer
      class Incrementing
        include ::Consumer

        def self.logger
          @logger ||= ::Log.get self
        end

        handler do |message_data|
          logger.info { "Handled event (StreamName: #{message_data.stream_name}, GlobalPosition: #{message_data.global_position})" }
        end

        handler do |message_data|
          logger.debug { message_data.data.pretty_inspect }
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
