module Consumer
  module Controls
    module Get
      class Incrementing
        configure :get

        initializer :sleep_duration

        def self.build(sleep_duration)
          new sleep_duration
        end

        def call(stream_name, position: nil)
          position ||= 0

          sleep Rational(sleep_duration, 1000)

          3.times.map do |offset|
            MessageData.get(
              stream_name,
              position + offset,
              offset
            )
          end
        end
      end

      class MessageData
        def self.get(stream_name, global_position, position)
          data = { :position => position, :global_position => global_position }

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
