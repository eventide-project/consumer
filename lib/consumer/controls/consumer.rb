module Consumer
  module Controls
    module Consumer
      def self.example
        Example.new(StreamName.example)
      end

      def self.example_class(identifier: nil, handlers: nil)
        if identifier == :none
          identifier = nil
        else
          identifier ||= Identifier.random
        end

        if handlers == :none
          handlers = []
        else
          handlers ||= [
            Handle::Example,
            Handle::Alternate::Example
          ]
        end

        Class.new do
          include ::Consumer

          handlers.each do |handler_cls|
            handler handler_cls
          end

          unless identifier.nil?
            identifier identifier
          end

          def configure(batch_size: nil, position_store: nil, settings: nil, **)
            Controls::Session::Example.configure(self, settings)

            Get::Example.configure(self)
            PositionStore::Example.configure(self, position_store: position_store)
          end
        end
      end

      Example = self.example_class
    end
  end
end
