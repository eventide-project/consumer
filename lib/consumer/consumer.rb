module Consumer
  def self.included(cls)
    cls.class_exec do
      extend StreamMacro
    end
  end

  def stream
    @stream ||= self.class.stream
  end

  module StreamMacro
    def stream_macro(name)
      stream = EventSource::Stream.new name

      define_singleton_method :stream do
        stream
      end
    end
    alias :stream :stream_macro
  end
end
