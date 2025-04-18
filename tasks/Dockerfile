FROM elixir:1.13.3-alpine

# install build dependencies
RUN apk update && \
    apk add postgresql-client build-base git

# prepare build dir
WORKDIR /app
RUN chown nobody /app

ARG MIX_ENV
# set build ENV
ENV MIX_ENV=$MIX_ENV

# install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# install mix dependencies
COPY mix.exs mix.lock ./
RUN mix deps.get
RUN mkdir config

# copy compile-time config files before we compile dependencies
# to ensure any relevant config change will trigger the dependencies
# to be re-compiled.
COPY config/config.exs config/${MIX_ENV}.exs config/
RUN mix deps.compile

# copy lib
COPY lib lib

# Copy entrypoint.sh to the correct location and set permissions
COPY tasks/entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

# Prevent the container from automatically starting Elixir
ENTRYPOINT ["/bin/sh"]

# Use the entrypoint script as the default command
CMD ["/app/entrypoint.sh"]