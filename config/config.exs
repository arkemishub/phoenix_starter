# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :arke_postgres, ArkePostgres.Repo,
  database: System.get_env("DB_NAME"),
  hostname: System.get_env("DB_HOSTNAME"),
  username: System.get_env("DB_USER"),
  password: System.get_env("DB_PASSWORD")

config :arke,
  persistence: %{
    arke_postgres: %{
      init: &ArkePostgres.init/0,
      create: &ArkePostgres.create/2,
      update: &ArkePostgres.update/2,
      delete: &ArkePostgres.delete/2,
      execute_query: &ArkePostgres.Query.execute/2,
      create_project: &ArkePostgres.create_project/1,
      delete_project: &ArkePostgres.delete_project/1
    }
  }

# Configures the endpoint
config :phoenix_starter, PhoenixStarterWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: PhoenixStarterWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: PhoenixStarter.PubSub,
  live_view: [signing_salt: "ODJKm1AE"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :arke_postgres, ecto_repos: [ArkePostgres.Repo]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Add Config for ArkeServer endpoints
config :arke_server, ArkeServer.Endpoint, server: false

# The endpoint module define which servers show in the swagger. You can pass a single one or a list
config :arke_server, endpoint_module: PhoenixStarterWeb.Endpoint

# Guardian configuration
config :arke_auth, ArkeAuth.Guardian,
  issuer: "arke_auth",
  secret_key: System.get_env("SECRET_KEY_BASE"),
  verify_issuer: true,
  token_ttl: %{"access" => {7, :days}, "refresh" => {30, :days}}

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
