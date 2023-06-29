defmodule PhoenixStarter.MixProject do
  use Mix.Project

  def project do
    [
      app: :phoenix_starter,
      version: "0.1.3",
      elixir: "~> 1.13",
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
    ])
  end

  defp arke_deps(:dev) do
    # Get arke's dependecies based on the env path. Also print a message only if the current command is mix deps.get
    mono_path = System.get_env("ARKE_MONOREPO_ELIXIR_PATH", nil)
    current_cmd = List.first(System.argv())

    with true <- mono_path != nil and mono_path != "" do
      if String.contains?(current_cmd, "deps.get") do
        IO.puts(
          "#{IO.ANSI.cyan()}ARKE_MONOREPO_ELIXIR_PATH found. Using local dependencies#{IO.ANSI.reset()}"
        )
      end

      [
        {:arke, path: "#{mono_path}/arke", override: true},
        {:arke_postgres, path: "#{mono_path}/arke_postgres", override: true},
        {:arke_auth, path: "#{mono_path}/arke_auth", override: true},
        {:arke_server, path: "#{mono_path}/arke_server", override: true}
      ]
    else
      _ ->
        if String.contains?(current_cmd, "deps.get") do
          IO.puts(
            "#{IO.ANSI.cyan()}ARKE_MONOREPO_ELIXIR_PATH not found. Using published dependencies#{IO.ANSI.reset()}"
          )
        end

        arke_deps(nil)
    end
  end

  defp arke_deps(_) do
    [
      {:arke, "~> 0.1.8"},
      {:arke_postgres, "~> 0.2.3"},
      {:arke_auth, "~> 0.1.4"},
      {:arke_server, "~> 0.1.9"}
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
