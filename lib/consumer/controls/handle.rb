module Consumer
  module Controls
    module Handle
      def self.example
        Example.new
      end

      module RecordMessages
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

      class Example
        include Messaging::Handle

        include RecordMessages

        attr_accessor :session

        def configure(session: nil)
          self.session = session
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

          include RecordMessages
        end
      end
    end
  end
end
