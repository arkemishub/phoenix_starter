# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

secret_key_auth =
  System.get_env("SECRET_KEY_AUTH") ||
    raise """
    environment variable SECRET_KEY_AUTH is missing.
    You can generate one by calling: mix guardian.gen.secret
    """

config :arke_auth, ArkeAuth.Guardian,
  issuer: "arke_auth",
  secret_key: secret_key_auth,
  verify_issuer: true,
  token_ttl: %{"access" => {7, :days}, "refresh" => {30, :days}}

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

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
