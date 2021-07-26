module Consumer
  module Controls
    module Handle
      module Settings
        Error = Class.new(RuntimeError)

        class Example
          include Messaging::Handle

          include ::Settings::Setting
          setting :some_setting

          attr_accessor :some_other_setting

          def configure(settings:)
            settings.set(self)
          end

          def handle(message_data)
            raise Settings::Error if some_setting.nil?
          end
        end
      end
    end
  end
end
