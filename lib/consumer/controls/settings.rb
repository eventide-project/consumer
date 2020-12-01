module Consumer
  module Controls
    module Settings
      def self.example
        ::Settings.build(data)
      end

      def self.data
        ::Settings::Controls::Data::Flat::Single.example
      end
    end
  end
end
