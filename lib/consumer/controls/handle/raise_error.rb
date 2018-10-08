module Consumer
  module Controls
    module Handle
      module RaiseError
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
