module Consumer
  module Controls
    module Writer
      def self.write(event_count=nil)
        event_count ||= 1

        stream_name = Stream::Name.random

        writer = EventStore::Client::HTTP::EventWriter.build

        event_count.times do |i|
          event_data = EventData::Write.example i

          writer.write event_data, stream_name
        end

        stream_name
      end
    end
  end
end
