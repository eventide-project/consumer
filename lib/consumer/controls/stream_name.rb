module Consumer
  module Controls
    module StreamName
      def self.example(stream_id: nil, category: nil)
        stream_id ||= ID.example
        category ||= Category.example

        EventSource::StreamName.stream_name category, stream_id
      end

      module Category
        def self.example(category=nil)
          category ||= Controls::Category.example
          category
        end
      end
    end
  end
end
