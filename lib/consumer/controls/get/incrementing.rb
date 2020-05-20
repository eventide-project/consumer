module Consumer
  module Controls
    module Get
      class Incrementing
        include ::Configure
        include Initializer

        configure :get

        def frequency_milliseconds
          @frequency_milliseconds ||= Defaults.frequency_milliseconds
        end
        attr_writer :frequency_milliseconds

        def frequency_seconds
          frequency_milliseconds.to_f / 1000
        end

        def self.build(frequency_milliseconds=nil)
          instance = new
          instance.frequency_milliseconds = frequency_milliseconds
          instance
        end

        def stream_name
          Category.example
        end

        def batch_size
          Defaults.batch_size
        end

        def call(position)
          position ||= 0

          sleep(frequency_seconds)

          batch_size.times.map do |offset|
            MessageData.example(
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
          def self.example(global_position, position)
            data = {
              :position => position,
              :global_position => global_position
            }

            Controls::MessageData.example(
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
