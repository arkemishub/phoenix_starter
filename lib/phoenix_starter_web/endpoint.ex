defmodule PhoenixStarterWeb.Endpoint do

  use Phoenix.Endpoint, otp_app: :phoenix_starter


  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  @session_options [
    store: :cookie,
    key: "_phoenix_starter_key",
    signing_salt: "FzcySPKO",
    same_site: "Lax"
  ]

  

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  # CORS configuration
  unless Mix.env() == :dev do
    plug(Corsica, origins: "*", allow_headers: :all)
  else
    plug(Corsica, origins: "*", allow_headers: :all)
  end

  plug Plug.MethodOverride
  plug Plug.Head
  plug Plug.Session, @session_options
  plug PhoenixStarterWeb.Plug.Router
end
