module Consumer
  module Controls
    module Consumer
      class Incrementing
        include ::Consumer
        include ::Log::Dependency

        module Handlers
          class PrintSummary
            include Messaging::Handle
            include Log::Dependency

            def handle(message_data)
              logger.info { "Handled event (StreamName: #{message_data.stream_name}, GlobalPosition: #{message_data.global_position})" }
            end
          end

          class PrintData
            include Messaging::Handle
            include Log::Dependency

            def handle(message_data)
              logger.debug { message_data.data.pretty_inspect }
            end
          end
        end

        handler Handlers::PrintSummary
        handler Handlers::PrintData

        def configure(batch_size: nil, position_store: nil)
          sleep_duration = ENV['SLEEP_DURATION'] || 100
          sleep_duration = sleep_duration.to_i

          Get::Incrementing.configure(self, sleep_duration)

          PositionStore::LocalFile.configure(self, position_store: position_store)
        end
      end
    end
  end
end
