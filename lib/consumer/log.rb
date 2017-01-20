module Consumer
  class Log < ::Log
    include Log::Dependency

    def tag!(tags)
      tags << :consumer
      tags << :library
      tags << :verbose
    end
  end
end
