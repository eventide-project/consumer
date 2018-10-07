require_relative './interactive_init'

position_update_interval = ENV['POSITION_UPDATE_INTERVAL']&.to_i

Actor::Supervisor.start do
  stream_name = Controls::StreamName.example

  Controls::Consumer::Incrementing.start(stream_name, position_update_interval: position_update_interval)
end
