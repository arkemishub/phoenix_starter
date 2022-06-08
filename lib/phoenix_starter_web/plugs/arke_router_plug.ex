defmodule PhoenixStarterWeb.Plug.Router do
  use Plug.Router

  plug :match
  plug :dispatch

  # do not remove this line - init Arke router
  match "/lib/*_", to: ArkeServer.Router
  match _, to: PhoenixStarterWeb.Router
end