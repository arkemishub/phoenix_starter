import Config

config :phoenix_starter, PhoenixStarterWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: PhoenixStarterWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: PhoenixStarter.PubSub,
  live_view: [signing_salt: "oYbdKiWt"]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

########################################################################
### ARKE  ##############################################################
########################################################################

config :arke,
  persistence: %{
    arke_postgres: %{
      init: &ArkePostgres.init/0,
      create: &ArkePostgres.create/2,
      update: &ArkePostgres.update/2,
      delete: &ArkePostgres.delete/2,
      execute_query: &ArkePostgres.Query.execute/2,
      create_project: &ArkePostgres.create_project/1,
      delete_project: &ArkePostgres.delete_project/1,
      repo: ArkePostgres.Repo
    }
  }
config :arke_postgres, ecto_repos: [ArkePostgres.Repo]


# Add Config for ArkeServer endpoints
config :arke_server, ArkeServer.Endpoint, server: false

config :arke_server,:mailer_module, PhoenixStarter.Mailer

# The endpoint module define which servers show in the swagger. You can pass a single one or a list
config :arke_server, endpoint_module: PhoenixStarterWeb.Endpoint

# Guardian configuration
config :arke_auth, ArkeAuth.Guardian,
  issuer: "arke_auth",
  secret_key: System.get_env("SECRET_KEY_BASE"),
  verify_issuer: true,
  token_ttl: %{"access" => {7, :days}, "refresh" => {30, :days}}

########################################################################
### SSO ARKE  ##########################################################
########################################################################

# If you want to enable SSO uncomment the configuration below
#config :arke_auth, ArkeAuth.SSOGuardian,
#  issuer: "arke_auth",
#  secret_key: "MY-SECRET-KEY",
#  verify_issuer: true,
#  token_ttl: %{"access" => {1, :days}, "refresh" => {2, :days}}

#config :arke_server, ArkeServer.Plugs.OAuth,
#  providers: [
#  <provider name>: { <Strategy Module>, [ <strategy options> ] }
#  ]


# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
