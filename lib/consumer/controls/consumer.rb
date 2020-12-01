module Consumer
  module Controls
    module Consumer
      def self.example(category=nil, identifier: nil, handlers: nil)
        category ||= Category.example

        cls = example_class(identifier: identifier, handlers: handlers)

        cls.new(category)
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
            Handle.example_class,
            Handle.example_class
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

            self.get = Get.example

            PositionStore::Example.configure(self)
          end

          def handled_messages
            handled_messages = []

            self.class.handler_registry.each do |handler|
              next unless handler.ancestors.include?(Handle)

              handled_messages += handler.handled_messages
            end

            handled_messages
          end
        end
      end

      Example = self.example_class

      module Settings
        def self.example_class
          Consumer.example_class(handlers: [Handle::Settings::Example])
        end

        Example = self.example_class
      end
    end
  end
end
