module Consumer
  class Log < ::Log
    include Log::Dependency

    def tag!(tags)
      tags << :consumer
    end
  end
end
