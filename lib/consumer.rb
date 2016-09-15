require 'fiber'

require 'actor'
require 'initializer'; Initializer.activate
require 'telemetry'
require 'telemetry/logger'

require 'consumer/message_buffer'
require 'consumer/subscription'

require 'consumer/consumer'
