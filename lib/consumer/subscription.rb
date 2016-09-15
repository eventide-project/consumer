module Consumer
  class Subscription
    include Actor
    include Telemetry::Logger::Dependency

    dependency :reader
    dependency :queue, MessageBuffer::Queue

    def configure
      MessageBuffer.configure_queue self
    end

    def fiber
      @fiber ||= Fiber.new do
        reader.each do |event_data|
          Fiber.yield event_data
        end
      end
    end

    handle :start do
      :read_next
    end

    handle :cycle do
      event_data = fiber.transfer

      message = Messages::EnqueueEvent.new
      message.event_data = event_data
      message
    end

    handle :enqueue_event do |msg|
      event_data = msg.event_data

      begin
        queue.enq event_data, true
      rescue ThreadError
        return msg
      end

      :cycle
    end
  end
end
