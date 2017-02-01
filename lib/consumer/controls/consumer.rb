module Consumer
  module Controls
    module Consumer
      def self.example
        Example.new StreamName.example
      end

      class Example
        include ::Consumer

        handler Handle::Example

        def configure(session: nil, batch_size: nil, position_store: nil)
          Get::Example.configure self
          PositionStore::Example.configure self, position_store: position_store
        end
      end
    end
  end
end
