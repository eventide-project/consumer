module Consumer
  module Controls
    module Session
      def self.example(settings=nil)
        Example.build(settings)
      end

      class Example
        extend ::Settings::Setting::Macro

        setting :some_setting
        setting :other_setting

        def self.build(settings=nil)
          settings ||= Settings.example

          instance = new
          settings.set(instance)
          instance
        end

        def settings?(other_settings)
          self.some_setting == other_settings.some_setting &&
            self.other_setting == other_settings.other_setting
        end
        alias_method :==, :settings?
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
