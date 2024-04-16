module Consumer
  module Controls
    module Position
      def self.example
        Global.example
      end

      module Stream
        def self.example
          MessageStore::Controls::MessageData.position
        end
      end

      module Global
        def self.example(offset: nil)
          offset ||= 0

          start + offset
        end

        def self.start
          11
        end
      end
    end
  end
end
