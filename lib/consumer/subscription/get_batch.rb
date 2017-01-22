module Consumer
  class Subscription
    GetBatch = Struct.new :reply_address

    class GetBatch
      include ::Actor::Messaging::Message

      def reply_message(batch)
        Reply.new batch
      end

      Reply = Struct.new :batch do
        include ::Actor::Messaging::Message
      end
    end
  end
end
