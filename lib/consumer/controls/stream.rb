module Consumer
  module Controls
    module Stream
      module ID
        def self.example(i=nil)
          Controls::ID.example i
        end
      end

      module Name
        def self.example
          stream_id = ID.example

          "someStream-#{stream_id}"
        end
      end

      module Category
        def self.example(random=nil)
          :some_stream
        end

        def self.random
          random = Identifier::UUID::Random.get
          random.gsub! '-', ''

          [example, random].compact.join.to_sym
        end

        module EventStore
          def self.example
            '$ce-someStream'
          end
        end
      end
    end
  end
end
