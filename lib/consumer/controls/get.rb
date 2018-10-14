module Consumer
  module Controls
    module Get
      def self.example(batch_size: nil)
        Example.build(batch_size: batch_size)
      end

      def self.default_batch_size
        MessageData::Batch.size
      end

      class Example
        include ::Configure

        include MessageStore::Get

        initializer :batch_size

        configure :get

        def self.build(batch_size: nil)
          batch_size ||= Get.default_batch_size

          new(batch_size)
        end

        def call(stream_name, position: nil)
          position ||= 0

          stream = streams.fetch(stream_name) do
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
