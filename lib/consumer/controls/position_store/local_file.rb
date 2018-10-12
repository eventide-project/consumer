module Consumer
  module Controls
    module PositionStore
      class LocalFile
        include Consumer::PositionStore
        include Initializer

        initializer(:identifier)

        def self.build(identifier: nil)
          instance = new(identifier)
          instance.configure
          instance
        end

        def get
          return 0 unless File.exist?(path)

          text = File.read(path)
          text.to_i
        end

        def put(position)
          File.write(path, position)
        end

        def path
          path = File.join('tmp', 'local_file_position_store')

          unless identifier.nil?
            path << "-#{identifier}"
          end

          path
        end
      end
    end
  end
end
