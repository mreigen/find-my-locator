import Config

version = Mix.Project.config()[:version]

config :find_my_locator,
  ecto_repos: [FindMyLocator.Repo],
  version: version

config :phoenix, :json_library, Jason

config :find_my_locator, FindMyLocatorWeb.Endpoint,
  pubsub_server: FindMyLocator.PubSub,
  render_errors: [view: FindMyLocatorWeb.Errors, accepts: ~w(html json)]

config :find_my_locator, FindMyLocator.Repo,
  migration_primary_key: [type: :binary_id, default: {:fragment, "gen_random_uuid()"}],
  migration_timestamps: [type: :utc_datetime_usec],
  start_apps_before_migration: [:ssl]

config :find_my_locator, Corsica, allow_headers: :all

config :find_my_locator, FindMyLocator.Gettext, default_locale: "en"

config :find_my_locator, FindMyLocatorGraphQL, token_limit: 2000

config :find_my_locator, FindMyLocatorWeb.Plugs.Security, allow_unsafe_scripts: false

config :absinthe_security, AbsintheSecurity.Phase.MaxAliasesCheck, max_alias_count: 100
config :absinthe_security, AbsintheSecurity.Phase.MaxDepthCheck, max_depth_count: 100
config :absinthe_security, AbsintheSecurity.Phase.MaxDirectivesCheck, max_directive_count: 100

config :esbuild,
  version: "0.16.4",
  default: [
    args: ~w(js/app.js --bundle --target=es2016 --outdir=../priv/static/assets),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

config :sentry,
  included_environments: [:all],
  root_source_code_path: File.cwd!(),
  release: version

config :logger, backends: [:console, Sentry.LoggerBackend]

# Import environment configuration
import_config "#{Mix.env()}.exs"
