# -----------------------------------------------
# Stage: npm dependencies
# -----------------------------------------------
FROM node:20.5-bookworm-slim AS npm-builder

# Install Debian dependencies
RUN apt-get update -y && \
    apt-get install -y build-essential git && \
    apt-get clean && \
    rm -f /var/lib/apt/lists/*_*

WORKDIR /app

# Install npm dependencies
COPY assets assets
RUN npm ci --prefix assets

# -----------------------------------------------
# Stage: hex dependencies
# -----------------------------------------------
FROM hexpm/elixir:1.15.5-erlang-26.0.2-debian-bookworm-20230612-slim AS otp-builder

# Install Debian dependencies
RUN apt-get update -y && \
    apt-get install -y build-essential git && \
    apt-get clean && \
    rm -f /var/lib/apt/lists/*_*

WORKDIR /app

# Install Erlang dependencies
RUN mix local.rebar --force && \
    mix local.hex --force

ENV MIX_ENV="prod"

# Install mix dependencies
COPY mix.exs mix.lock ./
RUN mix deps.get --only $MIX_ENV

# Copy compile-time config files before we compile dependencies
# to ensure any relevant config change will trigger the dependencies
# to be re-compiled.
RUN mkdir config
COPY config/config.exs config/${MIX_ENV}.exs config/

# Compile mix dependencies
RUN mix deps.compile

# Compile assets
COPY --from=npm-builder /app/assets assets
COPY priv priv
RUN mix assets.deploy

# Compile code
COPY lib lib
RUN mix compile

# Changes to config/runtime.exs don't require recompiling the code
COPY config/runtime.exs config/

COPY rel rel
RUN mix release

# -----------------------------------------------
# Stage: Bundle release in a docker image
# -----------------------------------------------
FROM debian:bookworm-20230612-slim

RUN apt-get update -y && \
    apt-get install -y libstdc++6 openssl libncurses5 locales && \
    apt-get clean && \
    rm -f /var/lib/apt/lists/*_*

# Set the locale
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

WORKDIR "/app"
RUN chown nobody /app

# Only copy the final release from the build stage
COPY --from=otp-builder --chown=nobody:root /app/_build/prod/rel/find_my_locator ./

USER nobody

CMD ["sh", "-c", "/app/bin/migrate && /app/bin/server"]
