module Consumer
  module MessageBuffer
    def self.configure_queue(receiver, attr_name: nil)
      attr_name ||= :queue

      queue = SizedQueue.new Size.get
      receiver.public_send "#{attr_name}=", queue
      queue
    end

    module Queue
      module Substitute
        def self.build
          SizedQueue.new 1
        end
      end
    end

    module Size
      def self.get
        Defaults.message_buffer_size
      end
    end

    module Defaults
      def self.message_buffer_size
        1000
      end
    end
  end
end
