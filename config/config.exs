import Config

#
# https://hexdocs.pm/logger/1.15.4/Logger.html
#

config :logger, :console,
  level: :error,
  format: "$time $message $metadata"

# or

#
# config :logger, :default_handler,
#   level: :error
#
# config :logger, :default_formatter,
#   format: "$time $message $metadata"
#
