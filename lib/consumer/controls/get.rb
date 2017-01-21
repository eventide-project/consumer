module Consumer
  module Controls
    module Get
      def self.example
        Example.new
      end

      class Example
        configure :get

        def self.build
          new
        end

        def call(stream_name, position: nil)
          position ||= 0

          stream = streams.fetch stream_name do
            return nil
          end

          stream[position]
        end

        def set_batch(stream_name, batch, position=nil)
          position ||= 0

          stream = streams[stream_name]

          stream[position] = batch
        end

        def streams
          @streams ||= Hash.new do |hash, key|
            hash[key] = {}
          end
        end
      end
    end
  end
end
