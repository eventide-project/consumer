require 'actor'

require 'configure'; Configure.activate
require 'messaging'
require 'log'

require 'consumer/log'

require 'consumer/defaults'
require 'consumer/handler_registry'
require 'consumer/position_store'
require 'consumer/position_store/substitute'
require 'consumer/position_store/telemetry'

require 'consumer/dispatcher'
require 'consumer/subscription'

require 'consumer/consumer'
