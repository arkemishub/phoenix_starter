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
mix arke.init
```

- Create your first project:

```bash
mix arke_postgres.create_project --id $PROJECT_NAME
```

- Create the all the data (arkes,parameters,groups) written in the `*.json` files under `lib/registry/`

```bash
mix arke.seed_project --project $PROJECT_NAME
```
- Create a super admin member
#####  Run `mix help arke_postgres.create_member` to get all the available options
```bash
mix arke_postgres.create_member --project $PROJECT_NAME  
```
- If you did not set a username and a password, use the credentials below to access the app:

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

## Deploy your app
There is a folder `rel` which is the output of the `mix phx.gen.releae` command.
To know more about phoenix releases [see](https://hexdocs.pm/phoenix/releases.html).

The release written above is used to create the docker image of our app. In order to do so run:

```bash
docker build -t your/tag --build-arg MIX_ENV=yourenv .
```
Once the docker image has been built you need these variables to make it work:
- `DB_NAME`
- `DB_HOSTNAME`
- `DB_USER`
- `DB_PASSWORD`
- `RELEASE_NAME`
- `SECRET_KEY_BASE` run `mix phx.gen.secret`
- `SECRET_KEY_AUTH` run`mix guardian.gen.secret`
- `HEADLESS_SERVICE_NAME`

The docker image created is meant to be used in a kubernetes environment.<br>
If you want use it somewhere else please edit the `runtime.exs` file accordingly.
Look for the `libcluster` topologies and set the right strategy. <br>
Remember to edit also the `env.sh.eex` file which export `RELEASE_NODE=phoenix_starter@${POD_IP}`, where `POD_IP` is inherited from the k8s pod. 
## Mailer
To use the mailer you must set the following environment variables:

```makefile
export MAIL_APIKEY=
export MAIL_DOMAIN=
export MAIL_DEFAULT_SENDER=
```

- Then run `source .env` to update the system environment variable
- Edit the file `mailer.ex` to use your templates 

To create your own email template override the `send_email` function and create your email struct using the [options available](https://hexdocs.pm/swoosh/Swoosh.Email.html). 
Then run the `deliver(email)`

## Single Sign On
To enable SSO for arke look for the SSO section in the `config.exs`. <br>
You will find the below configuration:
- `ArkeAuth.SSOGuardian`  is responsible for the creation of the jwt token used for the signup process.
- `ArkeServer.Plugs.OAuth` is where you will define all the provider you want enable.
- 

### Enable a provider
The configuration is composed as follows:
```
google: {ArkeServer.OAuth.Provider.Google, []}
<provider name>: { <Strategy Module>, [ <strategy options> ] }
```

`ArkeServer` provide differents provider like:
```
google: ArkeServer.OAuth.Provider.Google
facebook: ArkeServer.OAuth.Provider.Facebook
apple: ArkeServer.OAuth.Provider.Apple
github: ArkeServer.OAuth.Provider.Github
```
### Create your own Strategy Module
If you want to create our own strategy edit the `PhoenixStarter.Provider.MyProvider` as you like
and then use it in the configuration.


## How to contribute to arke developement

If you are glad to support us and contribute to the developement of Arke:

 <br/>

- clone the repo you want:
  - [arke](https://github.com/arkemishub/arke)
  - [arke_postgres](https://github.com/arkemishub/arke-postgres)
  - [arke_auth](https://github.com/arkemishub/arke-auth)
  - [arke_server](https://github.com/arkemishub/arke-server)

<br/>

- Add to your `.env` file the path of the cloned package:

```bash
export EX_DEP_${REPO_NAME}_PATH="PATH_TO_CLONED_REPO"

example EX_DEP_ARKE_POSTGRES_PATH="/path/to/arke_postgres/folder"
```

<br/>

- Run the [commands](#start-the-server) in the linked section. If you have previously installed the dependencies use the `clean` commands before install the deps again. (Use the `clean` also if you do not see your changes locally)

<br/>

By adding the `EX_DEP_{REPO_NAME}_PATH` variable you are able to use the arke's packages cloned locally.

<br/>

## Learn more

- Official website: https://www.phoenixframework.org/
- Guides: https://hexdocs.pm/phoenix/overview.html
- Docs: https://hexdocs.pm/phoenix
- Forum: https://elixirforum.com/c/phoenix-forum
- Source: https://github.com/phoenixframework/phoenix
