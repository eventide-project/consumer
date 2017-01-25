module Consumer
  module PositionStore
    module Telemetry
      class Sink
        include ::Telemetry::Sink

        record :get
        record :put
      end

      Get = Struct.new :position
      Put = Struct.new :position
    end
  end
end
