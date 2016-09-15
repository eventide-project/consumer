module Consumer
  module Controls
    module MessageBuffer
      module Full
        def self.configure_queue(receiver)
          queue = Queue.example
          receiver.queue = queue
          queue
        end

        module Queue
          def self.example
            message = Message.example

            queue = SizedQueue.new 1
            queue.enq message
            queue
          end
        end
      end
    end
  end
end
