module Consumer
  module Controls
    module Writer
      def self.write(event_count=nil)
        event_count ||= 1

        stream_name = Stream::Name.random

        writer = EventStore::Client::HTTP::EventWriter.build

        event_count.times do |i|
          event_data = EventData.example i

          writer.write event_data, stream_name
        end

        stream_name
      end

      module EventData
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
