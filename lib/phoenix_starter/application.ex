defmodule PhoenixStarter.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  alias Arke.Boundary.ArkeManager

  alias Arke.QueryManager

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      PhoenixStarterWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: PhoenixStarter.PubSub},
      # Start the Endpoint (http/https)
      PhoenixStarterWeb.Endpoint
      # Start a worker by calling: PhoenixStarter.Worker.start_link(arg)
      # {PhoenixStarter.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PhoenixStarter.Supervisor]
    seed()
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PhoenixStarterWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  defp seed() do
    data = [
      username: "default_user",
      password: "ArkPassDefault",
      type: "customer",
      first_name: "John",
      last_name: "Doe",
      phone_number: "504-621-8927",
      birth_date: "2022-12-12",
      first_access: true
    ]

    user_model = ArkeManager.get(:user, :arke_system)

    IO.puts("***** Checking database data *****")

    with nil <- QueryManager.get_by(username: data[:username], project: :arke_system) do
      IO.puts("***** Seeding database *****")
      QueryManager.create(:arke_system, user_model, data)
    else
      _ -> nil
    end
  end
end
