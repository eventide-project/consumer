module Consumer
  module Controls
    module Actor
      def self.example(subscription_address: nil, delay_threshold: nil)
        delay_threshold ||= DelayThreshold.example
        subscription_address ||= Address.example

        ::Consumer::Actor.new(subscription_address, delay_threshold)
      end

      module DelayThreshold
        def self.example
          11
        end
      end

      module Address
        def self.example
          ::Actor::Messaging::Address.build
        end
      end
    end
  end
end
