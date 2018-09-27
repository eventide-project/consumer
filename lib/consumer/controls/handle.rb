module Consumer
  module Controls
    module Handle
      def self.example
        Example.new
      end

      class Example
        include Messaging::Handle

        attr_accessor :session

        def configure(session: nil)
          self.session = session
        end

        def handle(message_data)
          handled_messages << message_data
        end

        def handled_messages
          @handled_messages ||= []
        end

        def handled?(message_data)
          handled_messages.include?(message_data)
        end

        def session?(session=nil)
          if session.nil?
            !self.session.nil?
          else
            session == self.session
          end
        end
      end

      module Alternate
        class Example
          include Messaging::Handle

          def handle(message_data)
            handled_messages << message_data
          end

          def handled_messages
            @handled_messages ||= []
          end

          def handled?(message_data)
            handled_messages.include?(message_data)
          end
        end
      end
    end
  end
end
