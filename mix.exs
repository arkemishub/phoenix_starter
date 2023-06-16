defmodule PhoenixStarter.MixProject do
  use Mix.Project

  def project do
    [
      app: :phoenix_starter,
      version: "0.1.0",
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

  defp arke_deps(:prod), do: arke_package()

  defp arke_deps(_) do
    # Get arke's dependecies based on the env path. Also print a message only if the current command is mix deps.get
    env_var = System.get_env()

    arke_env =
      Enum.filter(env_var, fn {k, _v} -> String.contains?(String.downcase(k), "ex_dep_arke") end)

    local_deps =
      Enum.reduce(arke_env, [], fn {package_name, local_path}, acc ->
        if local_path !== "" do
          parsed_name = String.replace(package_name, "EX_DEP_", "") |>  String.replace( "_PATH", "")|> String.downcase()
          IO.puts("#{IO.ANSI.cyan()} Using local #{parsed_name}#{IO.ANSI.reset()}")
          [{String.to_atom(parsed_name), path: local_path, override: true} | acc]
        else
          acc
        end
      end)

    deps = arke_package()

    filtered_deps =
      Enum.filter(deps, fn {k, _v} -> not Enum.member?(Keyword.keys(local_deps), k) end)

    filtered_deps ++ local_deps
  end

  defp arke_package() do
    [
      {:arke, "~> 0.1.4"},
      {:arke_postgres, "~> 0.1.4"},
      {:arke_auth, "~> 0.1.3"},
      {:arke_server, "~> 0.1.3"}
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
