module Consumer
  module Messages
    class EnqueueEvent
      include Schema::DataStructure
      include Actor::Messaging::Message

      attribute :event_data
    end
  end
end
