use Mix.Config

# Configures the endpoint
config :temp_tracker_ui, TempTrackerUiWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "JOMHgfzCnLKsRwlwBw4iJIeMlxRQ/SCiZfW70exC1XqVzeIRJmgSWr9c+riW9AlX",
  render_errors: [view: TempTrackerUiWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: TempTrackerUi.PubSub,
           adapter: Phoenix.PubSub.PG2]
