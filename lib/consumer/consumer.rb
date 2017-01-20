module Consumer
  def self.included(cls)
    cls.class_exec do
      extend StreamMacro
    end
  end

  module StreamMacro
    def stream_macro(stream_name)
      stream = EventSource::Stream.new stream_name

      define_method :stream do
        stream
      end
    end
    alias_method :stream, :stream_macro
  end
end
