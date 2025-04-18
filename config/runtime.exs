import Config

# The secret key base is used to sign/encrypt cookies and other secrets.
# A default value is used in config/dev.exs and config/test.exs but you
# want to use a different value for prod and you most likely don't want
# to check this value into version control, so we use an environment
# variable instead.


# Start the phoenix server if environment is set and running in a release
if System.get_env("PHX_SERVER") && System.get_env("RELEASE_NAME") do

  # Used to create the erlang cluster with differents pods
  config :libcluster,
         topologies: [
           erlang_nodes_in_k8s: [
             strategy: Elixir.Cluster.Strategy.Kubernetes.DNS,
             config: [
               service: System.get_env("HEADLESS_SERVICE_NAME"),
               application_name: System.get_env("RELEASE_NAME","phoenix_starter"),
               polling_interval: 10_000
             ]
           ]]

  config :phoenix_starter, PhoenixStarterWeb.Endpoint, server: true
  config :arke_server, ArkeServer.Endpoint, server: true

  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise """
      environment variable SECRET_KEY_BASE is missing.
      You can generate one by calling: mix phx.gen.secret
      """

  host = System.get_env("PHX_HOST") || "example.com"
  port = String.to_integer(System.get_env("PORT") || "4000")

  config :phoenix_starter, PhoenixStarterWeb.Endpoint,
    url: [host: host, port: 443],
    http: [
      # Enable IPv6 and bind on all interfaces.
      # Set it to  {0, 0, 0, 0, 0, 0, 0, 1} for local network only access.
      ip: {0, 0, 0, 0},
      port: port
    ],
    secret_key_base: secret_key_base
end


config :arke_postgres, ArkePostgres.Repo,
  database: System.get_env("DB_NAME"),
  hostname: System.get_env("DB_HOSTNAME"),
  username: System.get_env("DB_USER"),
  password: System.get_env("DB_PASSWORD")

# ## Using releases
#
# If you are doing OTP releases, you need to instruct Phoenix
# to start each relevant endpoint:
#
#     config :phoenix_starter, PhoenixStarterWeb.Endpoint, server: true
#
# Then you can assemble a release by calling `mix release`.
# See `mix help release` for more information.



# ## Configuring the mailer
#
# In production you need to configure the mailer to use a different adapter.
# Also, you may need to configure the Swoosh API client of your choice if you
# are not using SMTP. Here is an example of the configuration:
#
#     config :phoenix_starter, PhoenixStarter.Mailer,
#
#       adapter: Swoosh.Adapters.Local
#
#
# For this example you need include a HTTP client required by Swoosh API client.
# Swoosh supports Hackney and Finch out of the box:
#
#     config :swoosh, :api_client, Swoosh.ApiClient.Hackney
#
# See https://hexdocs.pm/swoosh/Swoosh.html#module-installation for details.

# Mailer configuration
config :phoenix_starter, PhoenixStarter.Mailer,
  adapter: Swoosh.Adapters.Local

# Guardian configuration
config :arke_auth, ArkeAuth.Guardian,
  issuer: "arke_auth",
  secret_key: System.get_env("SECRET_KEY_BASE"),
  verify_issuer: true,
  token_ttl: %{"access" => {7, :days}, "refresh" => {30, :days}}
