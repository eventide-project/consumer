module Consumer
  module Controls
    module Messages
      module DispatchEventData
        def self.example(i=nil)
          message = Consumer::Messages::DispatchEventData.new

          message.type = Event::Type.example
          message.data = Event::Data.example i
          message.metadata = Event::Metadata.example

          message.position = Event::Position::Stream.example
          message.global_position = Event::Position::Category.example
          message.stream_name = Stream::Name.example

          message
        end
      end
    end
  end
end
