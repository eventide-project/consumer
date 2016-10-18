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

      msg = Messages::DispatchEventData.new

      SetAttributes.(
        msg,
        event_data,
        copy: [
          :type,
          :data,
          :metadata,
          { :number => :position },
          { :position => :global_position },
          :stream_name
        ],
        strict: true
      )

      msg
    end

    handle :dispatch_event_data do |msg|
      begin
        queue.enq msg, true
      rescue ThreadError
        return msg
      end

      :cycle
    end
  end
end
