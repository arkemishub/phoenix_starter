defmodule PhoenixStarterWeb.Router do
  @moduledoc """
             Module where all the routes are defined. Too see the ones already available
             run in the CLI: `mix phx.routes ArkeServer.Router`.
             N.B. the /lib routes are relative to the arke_server package. To avoid future conflicts
             please use another path like /app
             """&& false
  use PhoenixStarterWeb, :router


  pipeline :api do
    plug :accepts, ["json"]
  end

  # Below define all the routes of your application
  scope "/app", PhoenixStarterWeb do
    pipe_through :api

    get "/", PageController, :home
  end

  
end
