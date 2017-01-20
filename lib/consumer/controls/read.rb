module Consumer
  module Controls
    module Read
      class Example
        include EventSource::Read

        def configure(batch_size: nil, precedence: nil, session: nil)
        end
      end
    end
  end
end
