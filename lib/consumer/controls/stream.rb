module Consumer
  module Controls
    module Stream
      module ID
        def self.example(i=nil)
          Controls::ID.example i
        end

        def self.random
          Identifier::UUID::Random.get
        end
      end

      module Name
        def self.example(stream_id=nil)
          stream_id ||= ID.example

          "someStream-#{stream_id}"
        end

        def self.random
          stream_id = ID.random

          example stream_id
        end
      end

      module Category
        def self.example(random=nil)
          :some_category
        end

        def self.random
          random = Identifier::UUID::Random.get
          random.gsub! '-', ''

          [example, random].compact.join.to_sym
        end

        module EventStore
          def self.example
            '$ce-someCategory'
          end
        end
      end
    end
  end
end
