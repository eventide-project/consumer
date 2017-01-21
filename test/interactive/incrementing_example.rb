require_relative './interactive_init'

Actor::Supervisor.start do
  Controls::Consumer::Incrementing.start
end
