defmodule PhoenixStarter.MixProject do
  use Mix.Project

  def project do
    [
      app: :phoenix_starter,
      version: "0.1.0",
      elixir: "~> 1.12",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {PhoenixStarter.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Logs info regarding Arke deps
  require Logger

  if System.get_env("ARKE_MONOREPO_ELIXIR_PATH") do
    Logger.info("Arke deps PATH: #{System.get_env("ARKE_MONOREPO_ELIXIR_PATH")}")
  else
    Logger.alert("Arke deps FAILED: Set ARKE_MONOREPO_ELIXIR_PATH on your .zshenv")
  end

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    List.flatten([
      {:corsica, "~> 1.2"},
      {:phoenix, "~> 1.6.6"},
      {:telemetry_metrics, "~> 0.6"},
      {:telemetry_poller, "~> 1.0"},
      {:jason, "~> 1.2"},
      {:plug_cowboy, "~> 2.5"},
      get_arke_deps(Mix.env())
    ])
  end

  defp get_arke_deps(_env) do
    [
      {:arke, "~> 0.1.1"},
      {:arke_postgres, "~> 0.1.0"},
      {:arke_auth, "~> 0.1.0"},
      {:arke_server, "~> 0.1.0"}
    ]
  end

  defp get_arke_deps(:dev) do
    [
      {:arke, path: "#{System.get_env("ARKE_MONOREPO_ELIXIR_PATH")}/apps/arke"},
      {:arke_postgres, path: "#{System.get_env("ARKE_MONOREPO_ELIXIR_PATH")}/apps/arke_postgres"},
      {:arke_auth, path: "#{System.get_env("ARKE_MONOREPO_ELIXIR_PATH")}/apps/arke_auth"},
      {:arke_server, path: "#{System.get_env("ARKE_MONOREPO_ELIXIR_PATH")}/apps/arke_server"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get"]
    ]
  end
end
