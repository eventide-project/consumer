module Consumer
  module Controls
    module Consumer
      module ErrorHandler
        def self.example(category=nil)
          category ||= Category.example

          Example.new(category)
        end

        class Example
          include ::Consumer

          attr_accessor :handled_error
          attr_accessor :failed_message

          handler Handle::Example
          handler Handle::RaiseError

          def error_raised(error, message)
            self.handled_error = error
            self.failed_message = message
          end

          def handled_error?(error=nil)
            if error.nil?
              !handled_error.nil?
            else
              handled_error == error
            end
          end

          def failed_message?(message)
            failed_message == message
          end
        end
      end
    end
  end
end
