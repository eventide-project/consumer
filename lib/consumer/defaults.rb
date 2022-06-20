module Consumer
  module Defaults
    def self.position_update_interval
      env_interval = ENV['POSITION_UPDATE_INTERVAL']
      return env_interval.to_i if !env_interval.nil?

      100
    end
  end
end
