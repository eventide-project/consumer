module Consumer
  module Controls
    module Handle
      module Settings
        def self.example
          Example.new
        end

        def self.example_class(&block)
          Class.new do
            include Messaging::Handle

            attr_accessor :some_setting

            # TODO: Delete class build method when the implementation in Messaging::Handle has a settings argument (Nathan Ladd: Mon Nov 30 2020)
            def self.build(strict: nil, session: nil, settings: nil)
              instance = new
              instance.strict = strict

              unless settings.nil?
                unless settings.instance_of?(::Settings)
                  settings = ::Settings.build(settings)
                end

                settings.set(instance, strict: false)
              end

              if Messaging::Handle::Build.configure_session?(instance)
                instance.configure(session: session)
              else
                instance.configure
              end

              instance
            end

            # TODO: Delete class call method when the implementation in Messaging::Handle has a settings argument (Nathan Ladd: Mon Nov 30 2020)
            def self.call(message_data, strict: nil, session: nil, settings: nil)
              handler = build(strict: strict, session: session, settings: settings)
              handler.(message_data)
            end

            def settings?(settings)
              some_setting == settings.get(:some_setting)
            end

            class_exec(&block) unless block.nil?
          end
        end

        Example = self.example_class
      end
    end
  end
end
