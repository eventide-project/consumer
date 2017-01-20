module Consumer
  class Dispatcher
    include Log::Dependency

    configure :dispatcher

    attr_writer :handlers

    def handlers
      @handlers ||= []
    end

    attr_writer :subscription_address

    def subscription_address
      @subscription_address ||= Actor::Messaging::Address::None
    end

    dependency :position_store, PositionStore

    def self.build(subscription_address: nil, position_store: nil)
      instance = new
      instance.subscription_address = subscription_address unless subscription_address.nil?
      instance.position_store = position_store if position_store
      instance
    end
  end
end
