import Config

# config/runtime.exs is executed for all environments, including
# during releases. It is executed after compilation and before the
# system starts, so it is typically used to load production configuration
# and secrets from environment variables or elsewhere. Do not define
# any compile-time configuration in here, as it won't be applied.
# The block below contains prod specific runtime configuration.

# ---- oauth ----
#config :ueberauth, Ueberauth.Strategy.Google.OAuth,
#  client_id:
#    System.get_env(
#      "GOOGLE_CLIENT_ID",
#      "574564377212-u90flrdprll6la0qg7ctl7s19jitur8k.apps.googleusercontent.com"
#    ),
#  client_secret: System.get_env("GOOGLE_CLIENT_SECRET", "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"),
#  redirect_uri:
#    System.get_env("GOOGLE_REDIRECT_URI", "http://localhost:4000/lib/auth/signin/google/callback")
#
#config :ueberauth, Ueberauth.Strategy.Github.OAuth,
#  client_id: System.get_env("GITHUB_CLIENT_ID", "7b3d14a789d2715a06a3"),
#  client_secret:
#    System.get_env("GITHUB_CLIENT_SECRET", "ae67c621bf91843a4b382276f3bb2974ac4bb54a"),
#  redirect_uri:
#    System.get_env("GITHUB_REDIRECT_URI", "http://localhost:4000/lib/auth/signin/github/callback")
#
#config :ueberauth, Ueberauth.Strategy.Facebook.OAuth,
#  client_id: System.get_env("FACEBOOK_CLIENT_ID", "1437210146848437"),
#  client_secret: System.get_env("FACEBOOK_CLIENT_SECRET", "715ceab4e8ef1da507206ee471240daa"),
#  redirect_uri:
#    System.get_env(
#      "FACEBOOK_REDIRECT_URI",
#      "http://localhost:4000/lib/auth/signin/facebook/callback"
#    )
#
#config :ueberauth, Ueberauth.Strategy.Apple.OAuth,
#  client_id: "com.khooa.app.applesignintest",
#  client_secret: {ArkeServer.Utils.Apple, :client_secret},
#  redirect_uri:
#    "https://1523-2a0e-410-2279-0-cf8-4cd6-816c-6621.ngrok-free.app/lib/auth/signin/apple/callback"

# ---- end oauth ----

# Start the phoenix server if environment is set and running in a release
if System.get_env("PHX_SERVER") && System.get_env("RELEASE_NAME") do
  config :phoenix_starter, PhoenixStarterWeb.Endpoint, server: true
end

if config_env() == :prod do
  # The secret key base is used to sign/encrypt cookies and other secrets.
  # A default value is used in config/dev.exs and config/test.exs but you
  # want to use a different value for prod and you most likely don't want
  # to check this value into version control, so we use an environment
  # variable instead.
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
      # See the documentation on https://hexdocs.pm/plug_cowboy/Plug.Cowboy.html
      # for details about using IPv6 vs IPv4 and loopback vs public addresses.
      ip: {0, 0, 0, 0, 0, 0, 0, 0},
      port: port
    ],
    secret_key_base: secret_key_base

  # ## Using releases
  #
  # If you are doing OTP releases, you need to instruct Phoenix
  # to start each relevant endpoint:
  #
  #     config :phoenix_starter, PhoenixStarterWeb.Endpoint, server: true
  #
  # Then you can assemble a release by calling `mix release`.
  # See `mix help release` for more information.
end
