import Config

defmodule TestEnvironment do
  @moduledoc false
  @database_name_suffix "_test"

  def get_database_url do
    url = System.get_env("DATABASE_URL")

    if is_nil(url) || String.ends_with?(url, @database_name_suffix) do
      url
    else
      raise "Expected database URL to end with '#{@database_name_suffix}', got: #{url}"
    end
  end
end

config :find_my_locator, FindMyLocator.Repo,
  pool: Ecto.Adapters.SQL.Sandbox,
  url: TestEnvironment.get_database_url()

config :find_my_locator, FindMyLocatorWeb.Endpoint, server: false

# This config is to output keys instead of translated message in test
config :find_my_locator, FindMyLocator.Gettext, priv: "priv/null", interpolation: FindMyLocator.GettextInterpolation

config :logger, level: :warning
