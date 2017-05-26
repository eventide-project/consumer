module Consumer
  module Controls
    module MessageData
      def self.example(stream_name: nil, data: nil, position: nil, global_position: nil)
        global_position ||= position

        message_data = MessageStore::Controls::MessageData::Read.example(data: data)
        message_data.stream_name = stream_name unless stream_name.nil?
        message_data.position = position unless position.nil?
        message_data.global_position = global_position unless global_position.nil?
        message_data
      end
    end
  end
end
