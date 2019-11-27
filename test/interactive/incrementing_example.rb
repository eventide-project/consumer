require_relative './interactive_init'

identifier = ENV['IDENTIFIER']

position_update_interval = ENV['POSITION_UPDATE_INTERVAL']&.to_i

Actor::Supervisor.start do
  category = Controls::Category.example

  Controls::Consumer::Incrementing.start(category, identifier: identifier, position_update_interval: position_update_interval)
end

test/interactive/incrementing_example.rb
