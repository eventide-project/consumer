module Consumer
  module Controls
    module Handle
      def self.example
        Example.new
      end

      module RecordMessages
        def self.included(cls)
          cls.extend(HandledMessages)
        end

        def handle(message_data)
          handled_messages << message_data
        end

        def handled_messages
          self.class.handled_messages
        end

        def handled?(message_data=nil)
          self.class.handled?(message_data)
        end

        module HandledMessages
          def handled_messages
            @@handled_messages ||= []
          end

          def clear_handled_messages
            handled_messages.clear
          end

          def handled?(message_data=nil)
            if message_data.nil?
              handled_messages.any?
            else
              handled_messages.include?(message_data)
            end
          end
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

      module Fail
        class Example
          include Messaging::Handle

          def handle(message_data)
            error_text = "Example error (Message: #{message_data.type}, Stream: #{message_data.stream_name}, Position: #{message_data.position}, Global Position: #{message_data.global_position})"

            raise Error::Example, error_text
          end
        end
      end
    end
  end
end
