ENV['LOG_LEVEL'] ||= 'info'

require 'io/console'

require_relative './interactive_init'

class ExampleConsumer
  include Consumer

  class Handler
    include Messaging::Handle
    include Log::Dependency

    def handle(message_data)
      raise_error = raise_error?

      attributes_log_text = "Message: #{message_data.type}, Position: #{message_data.position}, Global Position: #{message_data.global_position}, Raise Error: #{raise_error}"

      logger.trace { "Handling message data (#{attributes_log_text})" }

      if raise_error
        logger.error { "Raising error (#{attributes_log_text})" }

        raise Error, "Example error"
      end

      logger.info { "Message data handled (#{attributes_log_text})" }
    end

    def raise_error?
      (0...3).to_a.sample.zero?
    end

    Error = Class.new(RuntimeError)
  end
  handler Handler

  def error_raised(error, message_data)
    choice = nil

    loop do
      display_error_prompt

      choice = $stdin.getch.downcase

      if %r{[[:cntrl:]]}.match?(choice)
        puts "Exiting..."
        exit
      end

      puts choice

      case choice
      when 'r'
        self.(message_data)
        break

      when 'i'
        break

      when 'f'
        raise error
      end
    end
  end

  def configure
    Controls::Get::Incrementing.configure(self)
  end

  def display_error_prompt
    $stdout.print <<~TEXT.chomp
      The consumer raised an error. Choose how to proceed from the following options:

        r: retry (try dispatching the message again)
        f: fail (process will terminate)
        i: ignore (consumer will proceed to next message

      >
    TEXT
    $stdout.flush
  end
end

Actor::Supervisor.start do
  category = Controls::Category.example

  ExampleConsumer.start(category)
end
