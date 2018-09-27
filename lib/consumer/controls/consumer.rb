module Consumer
  module Controls
    module Consumer
      def self.example
        Example.new(StreamName.example)
      end

      class Example
        include ::Consumer

        handler Handle::Example

        def configure(batch_size: nil, position_store: nil, settings: nil, **)
          Controls::Session::Example.configure(self, settings)

          Get::Example.configure(self)
          PositionStore::Example.configure(self, position_store: position_store)
        end
      end
    end
  end
end
