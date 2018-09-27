module Consumer
  module Controls
    module Session
      def self.example(settings=nil)
        Example.build(settings)
      end

      class Example
        extend ::Configure::Macro
        extend ::Settings::Setting::Macro

        configure :session

        setting :some_setting
        setting :other_setting

        def self.build(settings=nil)
          settings ||= Settings.example

          instance = new
          settings.set(instance)
          instance
        end

        def settings?(other_settings)
          self.some_setting == other_settings.get(:some_setting) &&
            self.other_setting == other_settings.get(:other_setting)
        end

        def ==(other_session)
          other_session.is_a?(self.class) &&
            self.some_setting == other_session.some_setting &&
            self.other_setting == other_session.other_setting
        end
      end

      module Settings
        def self.example
          Example.build
        end

        class Example < ::Settings
          def self.data_source
            Raw.example
          end
        end

        module Raw
          def self.example
            {
              :some_setting => SecureRandom.hex(7),
              :other_setting => SecureRandom.hex(7)
            }
          end
        end
      end
    end
  end
end
