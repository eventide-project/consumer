module Consumer
  module Controls
    module Get
      class Incrementing
        include ::Configure
        include Initializer

        configure :get

        initializer :stream_name, :frequency_milliseconds

        def frequency_seconds
          frequency_milliseconds.to_f / 1000
        end

        def self.build(stream_name, frequency_milliseconds=nil)
          frequency_milliseconds ||= Defaults.frequency_milliseconds

          new(stream_name, frequency_milliseconds)
        end

        def batch_size
          Defaults.batch_size
        end

        def call(position)
          position ||= 0

          sleep(frequency_seconds)

          batch_size.times.map do |offset|
            MessageData.get(
              stream_name,
              position + offset,
              offset
            )
          end
        end

        module Defaults
          def self.frequency_milliseconds
            100
          end

          def self.batch_size
            3
          end
        end

        class MessageData
          def self.get(stream_name, global_position, position)
            data = {
              :position => position,
              :global_position => global_position
            }

            Controls::MessageData.example(
              stream_name: stream_name,
              data: data,
              global_position: global_position,
              position: position
            )
          end
        end
      end
    end
  end
end
