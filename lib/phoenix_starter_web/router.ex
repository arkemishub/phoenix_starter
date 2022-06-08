defmodule PhoenixStarterWeb.Router do
  use PhoenixStarterWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", PhoenixStarterWeb do
    pipe_through :api
  end
end
