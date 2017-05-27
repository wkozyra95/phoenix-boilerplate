# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :starter_project,
  ecto_repos: [StarterProject.Repo]

# Configures the endpoint
config :starter_project, StarterProject.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "0FWXIVtod0kUAOSpSeXKilKC2MSjIAQAO/8J5r4YlqyaLG0YODftBNZQ3BrXihq4",
  render_errors: [view: StarterProject.ErrorView, accepts: ~w(json)],
  pubsub: [name: StarterProject.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
