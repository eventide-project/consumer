module Consumer
  module Controls
    module StreamName
      def self.example(stream_id: nil, category: nil, randomize_category: nil)
        stream_id ||= ID.example
        category ||= Category.example randomize_category: randomize_category

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
