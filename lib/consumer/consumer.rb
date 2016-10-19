module Consumer
  def self.included(cls)
    return if cls == Object

    cls.class_exec do
      extend StreamMacro

      initializer a(:stream_name, lazy('self.class.stream_name'))
    end
  end

  def stream
    @stream ||= EventSource::Stream.new stream_name
  end

  module StreamMacro
    def stream_macro(name)
      define_singleton_method :stream_name do
        name
      end
    end
    alias :stream :stream_macro
  end
end
