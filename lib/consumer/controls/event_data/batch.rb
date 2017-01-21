module Consumer
  module Controls
    module EventData
      module Batch
        def self.example(instances: nil)
          instances ||= 1

          (0...instances).map do |position|
            EventData.example position: position
          end
        end
      end
    end
  end
end
