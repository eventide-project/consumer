module Consumer
  module Controls
    module Event
      module Data
        def self.example(i=nil)
          value = Attribute.example i

          { :some_attribute => value }
        end

        module Attribute
          def self.example(i=nil)
            i ||= 0

            "some-value-#{i}"
          end
        end
      end

      module Metadata
        def self.example
          { :some_metadata_attribute => 'some metadata value' }
        end
      end

      module Position
        module Stream
          def self.example
            1
          end
        end

        module Category
          def self.example
            11
          end
        end
      end

      module Type
        def self.example
          'SomeEvent'
        end
      end
    end
  end
end
