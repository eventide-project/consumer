module Consumer
  module Controls
    module EventData
      def self.example(stream_name: nil, stream_position: nil, global_position: nil)
        stream_name ||= StreamName.example
        stream_position ||= Position::Stream.example
        global_position ||= Position::Global.example

        EventSource::Controls::EventData::Read.example(
          stream_name: stream_name,
          stream_position: stream_position,
          global_position: global_position
        )
      end
    end
  end
end
