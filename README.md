## Usage

### Defining a Consumer Class

```ruby
class SomeConsumer
  include Consumer

  # Specifies a dispatcher implementation for handling messages
  dispatcher SomeDispatcher

  # Size (in messages) of the buffer that stores messages that have been read
  # from the subscription but not yet dispatched. Optional; default value is
  # shown.
  message_buffer_size 1000

  # The configure method should configure a subscription for the particular
  # database being consumed. Any additional dependencies declared for this
  # particular consumer class should be configured here as well.
  def configure
    # Configure a PostgreSQL subscription
    EventStream::Postgres::Read.configure self, stream_name: stream_name, category: category, delay_milliseconds: 1000

    # - OR -

    # Configure an EventStore subscription
    EventStore::Messaging::Subscription.configure self, stream_name, attr_name: :subscription
  end

  # Errors are handled by this method. If omitted, the default action when an
  # error is raised during the dispatching of a message is to re-raise the error
  def error_raised(error, event_data)
    SomeErrorNotificationService.(error)

    WriteNotProcessable.(event_data)
  end
end
```

### Using a Consumer Class

The consumer can be started directly or through [process-host](https://github.com/eventide-project/process-host). Use of ProcessHost is recommended for services deployed to a production environment.

#### Starting a Consumer Directly

```ruby
SomeConsumer.start category: :some_category
```

#### Starting via ProcessHost

**TBD**

## License

The `consumer` library is released under the [MIT License](https://github.com/eventide-project/event-stream-postgres/blob/master/MIT-License.txt).
