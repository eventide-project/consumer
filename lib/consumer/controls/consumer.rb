module Consumer
  module Controls
    module Consumer
      def self.example
        Example.new
      end

      class Example
        include ::Consumer

        stream StreamName.example
      end
    end
  end
end
