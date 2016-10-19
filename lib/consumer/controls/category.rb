module Consumer
  module Controls
    module Category
      def self.example(randomize_category: nil)
        randomize_category ||= false

        EventSource::Controls::Category.example randomize_category: randomize_category
      end
    end
  end
end
