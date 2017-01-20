module Consumer
  class Subscription
    include Log::Dependency

    configure :subscription

    attr_writer :handlers

    def handlers
      @handlers ||= []
    end

    def self.build
      instance = new
      instance
    end
  end
end
