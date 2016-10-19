module Consumer
  module Controls
    module Stream
      def self.example(stream_id: nil, category: nil)
        stream_name = StreamName.example stream_id: stream_id, category: category

        EventSource::Stream.new stream_name
      end

      module Category
        def self.example(category=nil)
          category ||= Controls::Category.example

          EventSource::Stream.new category
        end
      end
    end
  end
end
