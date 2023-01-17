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

  Logger.info(System.get_env("MIX_ENV"))

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
      arke_deps(Mix.env())

      # lib_arke(Mix.env()),
      # lib_postgres(Mix.env()),
      # lib_auth(Mix.env()),
      # lib_server(Mix.env())
      # {:arke, "~> 0.1.2", override: [:prod, :test], runtime: false},
      # {:arke_postgres, "~> 0.1.0", override: [:prod, :test], runtime: false},
      # {:arke_auth, "~> 0.1.0", override: [:prod, :test], runtime: false},
      # {:arke_server, "~> 0.1.0", override: [:prod, :test], runtime: false},
      # {:arke, path: "#{System.get_env("ARKE_MONOREPO_ELIXIR_PATH")}/apps/arke", override: :dev, runtime: false},
      # {:arke_postgres, path: "#{System.get_env("ARKE_MONOREPO_ELIXIR_PATH")}/apps/arke_postgres", override: :dev, runtime: false},
      # {:arke_auth, path: "#{System.get_env("ARKE_MONOREPO_ELIXIR_PATH")}/apps/arke_auth", override: :dev, runtime: false},
      # {:arke_server, path: "#{System.get_env("ARKE_MONOREPO_ELIXIR_PATH")}/apps/arke_server", override: :dev, runtime: false}
    ])
  end

  defp arke_deps(:dev) do
    [
      {:arke, path: "#{System.get_env("ARKE_MONOREPO_ELIXIR_PATH")}/apps/arke", override: true},
      {:arke_postgres,
       path: "#{System.get_env("ARKE_MONOREPO_ELIXIR_PATH")}/apps/arke_postgres", override: true},
      {:arke_auth,
       path: "#{System.get_env("ARKE_MONOREPO_ELIXIR_PATH")}/apps/arke_auth", override: true},
      {:arke_server,
       path: "#{System.get_env("ARKE_MONOREPO_ELIXIR_PATH")}/apps/arke_server", override: true}
    ]
  end

  defp arke_deps(_) do
    [
      {:arke, "~> 0.1.2"},
      {:arke_postgres, "~> 0.1.2"},
      {:arke_auth, "~> 0.1.1"},
      {:arke_server, "~> 0.1.1"}
    ]
  end

  # defp lib_arke(:dev),
  #   do: {:arke, path: "#{System.get_env("ARKE_MONOREPO_ELIXIR_PATH")}/apps/arke"}

  # defp lib_arke(_), do: {:arke, "~> 0.1.1"}

  # defp lib_postgres(:dev),
  #   do:
  #     {:arke_postgres, path: "#{System.get_env("ARKE_MONOREPO_ELIXIR_PATH")}/apps/arke_postgres"}

  # defp lib_postgres(_), do: {:arke_postgres, "~> 0.1.0"}

  # defp lib_auth(:dev),
  #   do: {:arke_auth, path: "#{System.get_env("ARKE_MONOREPO_ELIXIR_PATH")}/apps/arke_auth"}

  # defp lib_auth(_), do: {:arke_auth, "~> 0.1.0"}

  # defp lib_server(:dev),
  #   do: {:arke_server, path: "#{System.get_env("ARKE_MONOREPO_ELIXIR_PATH")}/apps/arke_server"}

  # defp lib_server(_), do: {:arke_server, "~> 0.1.0"}

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
