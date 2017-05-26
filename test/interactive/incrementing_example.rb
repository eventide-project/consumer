require_relative './interactive_init'

Actor::Supervisor.start do
  stream_name = Controls::StreamName.example

  Controls::Consumer::Incrementing.start(stream_name)
end
