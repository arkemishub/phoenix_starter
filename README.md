# PhoenixStarter

To start your Phoenix server:

* Add on your `.zshenv` file the path of the `arke-monorepo`:

```bash
export ELIXIR_ARKE_MONOREPO=/Users/<YOUR_USER>/Workspace/Arke/arke-monorepo-elixir/
```

* In this way `arke_server` dependency points to your local version of the library:
```elixir
   {:arke_server, path: "#{System.get_env("ARKE_MONOREPO_ELIXIR_PATH")}"}
```
* Install dependencies with `mix deps.get`

* Add a `.env` file in the root of the project to set the DB env variables:
```
export DB_NAME=
export DB_HOSTNAME=
export DB_USER=
export DB_PASSWORD=
```

* Run `source .env`

* Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
