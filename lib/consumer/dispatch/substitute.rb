module Consumer
  class Dispatch
    module Substitute
      def self.build
        Dispatch.new
      end

      class Dispatch
        def call(message_data)
          dispatched_events << message_data
        end

        def add_handler(handle)
          handlers << handle
        end

        def dispatched_events
          @dispatched_events ||= []
        end

        def dispatched?(message_data=nil, &block)
          if message_data.nil?
            block ||= proc { true }
          else
            block ||= proc { |e| message_data == e }
          end

          dispatched_events.any? &block
        end

        def handlers
          @handlers ||= []
        end

        def handler?(handler)
          handlers.include? handler
        end
      end
    end
  end
end
