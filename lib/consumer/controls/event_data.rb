module Consumer
  module Controls
    module EventData
      module Read
        def self.example(i=nil)
          event_data = EventStore::Client::HTTP::EventData::Read.build

          event_data.type = Event::Type.example
          event_data.data = Event::Data.example i
          event_data.metadata = Event::Metadata.example

          event_data.number = Event::Position::Stream.example
          event_data.position = Event::Position::Category.example
          event_data.stream_name = Stream::Name.example

          event_data
        end
      end

      module Write
        def self.example(i=nil)
          event_data = EventStore::Client::HTTP::EventData::Write.build

          event_data.type = Event::Type.example
          event_data.data = Event::Data.example i
          event_data.metadata = Event::Metadata.example

          event_data.assign_id

          event_data
        end
      end
    end
  end
end
