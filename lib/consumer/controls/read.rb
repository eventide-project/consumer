module Consumer
  module Controls
    module Read
      class Example
        include EventSource::Read

        dependency :get

        def configure(batch_size: nil, precedence: nil, session: nil)
          self.get = Get.example
        end
      end
    end
  end
end
