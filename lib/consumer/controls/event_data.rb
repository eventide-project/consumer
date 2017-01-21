module Consumer
  module Controls
    module EventData
      def self.example(stream_name: nil, position: nil, global_position: nil)
        event_data = EventSource::Controls::EventData::Read.example
        event_data.stream_name = stream_name unless stream_name.nil?
        event_data.position = position unless position.nil?
        event_data.global_position = global_position unless global_position.nil?
        event_data
      end
    end
  end
end
