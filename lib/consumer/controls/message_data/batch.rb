module Consumer
  module Controls
    module MessageData
      module Batch
        def self.example(instances: nil, position: nil)
          instances ||= size
          start_position ||= Controls::Position::Global.example

          instances.times.map do |offset|
            position = start_position + offset

            MessageData.example(global_position: position)
          end
        end

        def self.size
          3
        end
      end
    end
  end
end
