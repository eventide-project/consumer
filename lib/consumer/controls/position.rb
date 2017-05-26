module Consumer
  module Controls
    module Position
      module Stream
        def self.example
          MessageStore::Controls::MessageData.position
        end
      end

      module Global
        def self.example(offset: nil)
          offset ||= 0

          position = MessageStore::Controls::MessageData::Read.global_position

          position + offset
        end
      end
    end
  end
end
