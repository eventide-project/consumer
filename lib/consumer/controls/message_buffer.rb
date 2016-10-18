module Consumer
  module Controls
    module MessageBuffer
      module Full
        module Queue
          def self.example
            message = :some_message

            queue = SizedQueue.new 1
            queue.enq message
            queue
          end
        end
      end
    end
  end
end
