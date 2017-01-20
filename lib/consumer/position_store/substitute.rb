module Consumer
  module PositionStore
    module Substitute
      def self.build
        PositionStore.new
      end

      class PositionStore
        attr_accessor :get_position
        attr_accessor :put_position

        def get
          get_position
        end

        def put(position)
          self.put_position = position
        end

        def put?(expected_position=nil)
          if expected_position.nil?
            put_position ? true : false
          else
            put_position == expected_position
          end
        end
      end
    end
  end
end
