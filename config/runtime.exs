import Config
import FindMyLocator.Config

canonical_uri = get_env("CANONICAL_URL", :uri)
static_uri = get_env("STATIC_URL", :uri)

config :find_my_locator,
  canonical_host: get_uri_part(canonical_uri, :host),
  force_ssl: get_uri_part(canonical_uri, :scheme) == "https"

config :find_my_locator, FindMyLocator.Repo,
  url: get_env!("DATABASE_URL"),
  ssl: get_env("DATABASE_SSL", :boolean),
  pool_size: get_env!("DATABASE_POOL_SIZE", :integer),
  socket_options: if(get_env("DATABASE_IPV6", :boolean), do: [:inet6], else: [])

# NOTE: Only set `server` to `true` if `PHX_SERVER` is present. We cannot set
# it to `false` otherwise because `mix phx.server` will stop working without it.
if get_env("PHX_SERVER", :boolean) == true do
  config :find_my_locator, FindMyLocatorWeb.Endpoint, server: true
end

config :find_my_locator, FindMyLocatorWeb.Endpoint,
  http: [port: get_env!("PORT", :integer)],
  secret_key_base: get_env!("SECRET_KEY_BASE"),
  session_key: get_env!("SESSION_KEY"),
  session_signing_salt: get_env!("SESSION_SIGNING_SALT"),
  live_view: [signing_salt: get_env!("SESSION_SIGNING_SALT")],
  url: get_endpoint_url_config(canonical_uri),
  static_url: get_endpoint_url_config(static_uri)

config :find_my_locator, Corsica, origins: get_env("CORS_ALLOWED_ORIGINS", :cors)

config :find_my_locator,
  basic_auth: [
    username: get_env("BASIC_AUTH_USERNAME"),
    password: get_env("BASIC_AUTH_PASSWORD")
  ]

config :find_my_locator, FindMyLocator.TelemetryUI, share_key: get_env("TELEMETRY_UI_SHARE_KEY")

config :sentry,
  dsn: get_env("SENTRY_DSN"),
  environment_name: get_env("SENTRY_ENVIRONMENT_NAME")

config :absinthe_security, AbsintheSecurity.Phase.IntrospectionCheck, enable_introspection: get_env("GRAPHQL_ENABLE_INTROSPECTION", :boolean)
config :absinthe_security, AbsintheSecurity.Phase.FieldSuggestionsCheck, enable_field_suggestions: get_env("GRAPHQL_ENABLE_FIELD_SUGGESTIONS", :boolean)
