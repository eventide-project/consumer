module Consumer
  module PositionStore
    module Telemetry
      class Sink
        include ::Telemetry::Sink

        record :get
        record :put
      end

      Get = Struct.new :position, :stream
      Put = Struct.new :position, :stream
    end
  end
end
