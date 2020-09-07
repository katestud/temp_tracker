# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :temp_tracker_ui, TempTrackerUiWeb.Endpoint,
  url: [host: "localhost"],
  http: [port: 80],
  server: true,
  root: Path.dirname(__DIR__),
  secret_key_base: "mnZo4Ic5J5XBcF2Htzmif4JQXi6ESkEVvnU7sgVyNU4Fbk/RPjr73+6lTxEOs85i",
  render_errors: [view: TempTrackerUiWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: TempTrackerUi.PubSub,
  live_view: [signing_salt: "ukecSYuC"],
  code_reloader: false

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :temp_tracker, temperature: TempTracker.Temperature

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
