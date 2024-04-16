module Consumer
  module Controls
    module Get
      def self.example(batch_size: nil)
        batch_size ||= self.batch_size

        MessageStore::Controls::Get.example(stream_name: stream_name, batch_size: batch_size)
      end

      def self.stream_name
        Category.example
      end

      def self.batch_size
        MessageData::Batch.size
      end
    end
  end
end
