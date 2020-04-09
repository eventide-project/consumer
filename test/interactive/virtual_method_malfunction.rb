require_relative './interactive_init'

class ExampleConsumer
  include Consumer

  def error_raised(error, message_data)
    puts
    puts "Virtual method #error_raised was invoked (Error: #{error.class}, Message Type: #{message_data.type})"
    puts
  end

  class Handler
    include Messaging::Handle

    def call(message_data)
      error = Controls::Error.example

      raise error
    end
  end
  handler Handler
end

message_data = Controls::MessageData.example

stream_name = "someCategory#{SecureRandom.hex}"

consumer = ExampleConsumer.new(stream_name)

consumer.(message_data)
