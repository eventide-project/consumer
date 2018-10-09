module Consumer
  module Controls
    module Get
      class Incrementing
        ::Configure.activate(self)

        configure :get

        initializer :frequency_milliseconds

        def frequency_seconds
          frequency_milliseconds.to_f / 1000
        end

        def self.build(frequency_milliseconds=nil)
          frequency_milliseconds ||= Defaults.frequency_milliseconds

          new(frequency_milliseconds)
        end

        def call(stream_name, position: nil)
          position ||= 0

          sleep(frequency_seconds)

          3.times.map do |offset|
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
