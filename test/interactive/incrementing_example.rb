require_relative './interactive_init'

Actor::Supervisor.start do
  stream = Controls::Stream.example

  Controls::Consumer::Incrementing.start stream
end
