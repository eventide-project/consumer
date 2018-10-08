module Consumer
  module Controls
    module Handle
      def self.example
        example_class.new
      end

      def self.example_class
        Class.new do
          include Messaging::Handle
          include Handle

          attr_accessor :session

          def configure(session: nil)
            self.session = session
          end

          def self.handled_messages
            @@handled_messages ||= []
          end

          def handle(message_data)
            handled_messages << message_data
          end

          def handled_messages
            self.class.handled_messages
          end

          def handled?(message_data=nil)
            if message_data.nil?
              handled_messages.any?
            else
              handled_messages.include?(message_data)
            end
          end

          def session?(session=nil)
            if session.nil?
              !self.session.nil?
            else
              session == self.session
            end
          end
        end
      end

      Example = self.example_class
    end
  end
end
