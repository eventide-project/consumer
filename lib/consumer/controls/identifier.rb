module Consumer
  module Controls
    module Identifier
      def self.example(random: nil)
        random ||= false

        unless random
          'some-consumer'
        else
          "some-consumer-#{SecureRandom.hex(8)}"
        end
      end

      def self.random
        example(random: true)
      end
    end
  end
end
