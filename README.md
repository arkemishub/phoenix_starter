# PhoenixStarter

## Requirements

- [Elixir](https://elixir-lang.org/install.html) (`~> 1.13`)
- [Postgres](https://www.postgresql.org/docs/14/tutorial-install.html) (`~> 14.5`)

<br/>

## Get started

- Add a `.env` file in the root of the project to set the DB env variables:

```makefile
export DB_NAME=
export DB_HOSTNAME=
export DB_USER=
export DB_PASSWORD=
```

- Run `source .env`

```bash
source .env
```

<br/>

## Start the server :

- Install dependencies:

```bash
mix deps.get
```

- Create the database and populate it:

##### N.B the env variables [above](#get-started) should be valorized. If you have done it now re-run the `source .env` command

```bash
mix ecto.create -r ArkePostgres.Repo
mix arke_postgres.init_db
mix ecto.migrate -r ArkePostgres.Repo
```

- Use the credentials below to access the app:

```
username = admin
pwd = admin
```

- Start Phoenix endpoint inside IEx:

```bash
iex -S mix phx.server
```

- If it is necessary clean old deps (`for local developement`):

```bash
mix deps.update --all
```

- Enjoy your app on [`localhost:4000`](http://localhost:4000)

<br/>

## How to contribute to arke developement

If you are glad to support us and contribute to the developement of Arke:

 <br/>

- clone the repo [arke-monorepo-elixir](https://github.com/arkemishub/arke-monorepo-elixir)

```bash
git clone git@github.com:arkemishub/arke-monorepo-elixir.git
```

- Pull the submodules

```bash
git pull --recurse-submodules
git submodule update --init
```

<br/>

- Add to your `.env` file the path of the cloned repo:

```bash
export ARKE_MONOREPO_ELIXIR_PATH= 'PATH_TO_ARKE_MONOREPO'
```

<br/>

- Run the [commands](#start-the-server) in the linked section. If you have previously installed the dependencies use the `clean` commands before install the deps again. (Use the `clean` also if you do not see your changes locally)

<br/>

By adding the `ARKE_MONOREPO_ELIXIR_PATH` variable you are able to use the arke's packages cloned locally. They must be in the same directory

<br/>

## Learn more

- Official website: https://www.phoenixframework.org/
- Guides: https://hexdocs.pm/phoenix/overview.html
- Docs: https://hexdocs.pm/phoenix
- Forum: https://elixirforum.com/c/phoenix-forum
- Source: https://github.com/phoenixframework/phoenix
