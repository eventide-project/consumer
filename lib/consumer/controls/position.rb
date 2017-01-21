module Consumer
  module Controls
    module Position
      module Stream
        def self.example
          EventSource::Controls::EventData.position
        end
      end

      module Global
        def self.example(offset: nil)
          offset ||= 0

          position = EventSource::Controls::EventData::Read.global_position

          position + offset
        end
      end
    end
  end
end
