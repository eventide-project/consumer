module Consumer
  module Controls
    module Consumer
      def self.example
        Example.new Stream.example
      end

      class Example
        include ::Consumer

        handle Handle::Example
        position_store PositionStore::Example

        def configure(session: nil, batch_size: nil)
          Get::Example.configure self
        end
      end
    end
  end
end
