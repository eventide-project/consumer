module Consumer
  module Controls
    module PositionStore
      class LocalFile
        include Consumer::PositionStore

        def get
          return 0 unless File.exist? path
          text = File.read path
          text.to_i
        end

        def put(position)
          File.write path, position
        end

        def path
          'tmp/control_position_store'
        end
      end
    end
  end
end
