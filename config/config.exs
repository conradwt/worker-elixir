import Config

config :logger, :console,
  level: :error,
  format: "$time $message $metadata"
