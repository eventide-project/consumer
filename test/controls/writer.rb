module Consumer
  module Controls
    module Writer
      def self.write(event_count=nil)
        event_count ||= 1

        stream_name = Stream::Name.example
        category = Controls::Stream::Category.random

        writer = EventStore::Client::HTTP::EventWriter.build

        event_count.times do |i|
          event_data = EventData.example i

          writer.write event_data, stream_name
        end

        stream_name
      end

      module EventData
        def self.example(i)
          dispatch_event_data = Messages::DispatchEventData.example i

          event_data = EventStore::Client::HTTP::EventData::Write.build

          SetAttributes.(
            event_data,
            dispatch_event_data,
            copy: %i(type data metadata),
            strict: true
          )

          event_data.assign_id

          event_data
        end
      end
    end
  end
end
