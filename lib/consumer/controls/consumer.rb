module Consumer
  module Controls
    module Consumer
      def self.example
        Example.new
      end

      class Example
        include ::Consumer

        stream StreamName.example
        handle Handle::Example
        reader Read::Example
      end
    end
  end
end
