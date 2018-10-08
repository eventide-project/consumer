module Consumer
  module Controls
    module Consumer
      def self.example(stream_name=nil, identifier: nil, handlers: nil)
        stream_name ||= StreamName.example

        cls = example_class(identifier: identifier, handlers: handlers)

        cls.new(stream_name)
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

          def configure(settings: nil, **)
            Controls::Session::Example.configure(self, settings)

            Get::Example.configure(self)
            PositionStore::Example.configure(self)
          end
        end
      end

      def self.clear_handled_messages
        Example.handler_registry.each do |handler|
          handler.clear_handled_messages
        end
      end

      def self.handled_messages(message_data=nil)
        handled_messages = []

        Example.handler_registry.each do |handler|
          if handler.handled?(message_data)
            handled_messages << message_data
          end
        end

        handled_messages
      end

      Example = self.example_class
    end
  end
end
