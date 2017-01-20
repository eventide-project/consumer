module Consumer
  module Controls
    module Position
      module Stream
        def self.example
          EventSource::Controls::EventData.position
        end
      end

      module Global
        def self.example
          EventSource::Controls::EventData::Read.global_position
        end
      end
    end
  end
end
