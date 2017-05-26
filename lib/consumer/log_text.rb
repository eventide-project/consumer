module Consumer
  module LogText
    def self.message_data(message_data)
      "Stream: #{message_data.stream_name}, Position: #{message_data.position}, GlobalPosition: #{message_data.global_position}, Type: #{message_data.type}"
    end
  end
end
