module Consumer
  class Subscription
    include Actor
    include Log::Dependency

    configure :subscription

    initializer :get, :stream_name

    attr_accessor :next_batch

    attr_writer :position
    def position
      @position ||= 0
    end

    dependency :cycle, Cycle

    def self.build(read)
      instance = new read.get, read.stream_name
      instance.position = read.iterator.position
      Cycle.configure instance, cycle: read.iterator.cycle
      instance
    end

    handle :start do
      :resupply
    end

    handle :resupply do
      batch = get.(stream_name, position: position)

      if batch.empty?
        :resupply
      else
        self.next_batch = batch
        nil
      end
    end

    handle :get_batch do |get_batch|
      batch = reset_next_batch

      reply_message = get_batch.reply_message batch

      send.(reply_message, get_batch.reply_address)

      :resupply
    end

    def reset_next_batch
      batch = next_batch

      self.next_batch = nil

      self.position = batch.last.global_position + 1

      batch
    end

    GetBatch = Struct.new :reply_address

    class GetBatch
      def reply_message(batch)
        Reply.new batch
      end

      Reply = Struct.new :batch
    end
  end
end
