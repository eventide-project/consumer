module Consumer
  class Subscription
    GetBatch = Struct.new :reply_address

    class GetBatch
      def reply_message(batch)
        Reply.new batch
      end

      Reply = Struct.new :batch
    end
  end
end
