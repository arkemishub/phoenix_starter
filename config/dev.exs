import Config

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with esbuild to bundle .js and .css sources.
config :phoenix_starter, PhoenixStarterWeb.Endpoint,
  # Binding to loopback ipv4 address prevents access from other machines.
  # Change to `ip: {0, 0, 0, 0}` to allow access from other machines.
  http: [ip: {127, 0, 0, 1}, port: 4000],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base: "pJsr+GA5YCBRF6F4h+CwPET/HDtMm8x7PZ0qQ1uEqjInnCSScFyHF12rroZb6kih",
  watchers: []

# ## SSL Support
#
# In order to use HTTPS in development, a self-signed
# certificate can be generated by running the following
# Mix task:
#
#     mix phx.gen.cert
#
# Note that this task requires Erlang/OTP 20 or later.
# Run `mix help phx.gen.cert` for more information.
#
# The `http:` config above can be replaced with:
#
#     https: [
#       port: 4001,
#       cipher_suite: :strong,
#       keyfile: "priv/cert/selfsigned_key.pem",
#       certfile: "priv/cert/selfsigned.pem"
#     ],
#
# If desired, both `http:` and `https:` keys can be
# configured to run both http and https servers on
# different ports.

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Initialize plugs at runtime for faster development compilation
config :phoenix, :plug_init_mode, :runtime

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

# Guardian configuration
config :arke_auth, ArkeAuth.Guardian,
  issuer: "arke_auth",
  secret_key: "qby4HTsDDHvf4fzGqlzBWHsUAZ8Pad6b0nI1+/mh7GXdM6XEiYYPRrtuQ3o/ISoF",
  verify_issuer: true,
  token_ttl: %{"access" => {1, :minute}, "refresh" => {30, :days}}
