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
      :cycle
    end

    handle :cycle do
      event_data = fiber.transfer

      begin
        queue.enq event_data, true
      rescue ThreadError
      end

      :cycle
    end
  end
end
