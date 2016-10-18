module Consumer
  module Messages
    class DispatchEventData
      include Schema::DataStructure
      include Actor::Messaging::Message

      attribute :type, String
      attribute :data, Hash
      attribute :metadata, Hash

      attribute :stream_name, String
      attribute :position, Integer
      attribute :global_position, Integer
    end
  end
end
