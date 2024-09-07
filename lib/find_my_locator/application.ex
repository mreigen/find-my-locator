defmodule FindMyLocator.Application do
  @moduledoc """
  Main entry point of the app
  """

  use Application

  def start(_type, _args) do
    children = [
      FindMyLocator.Repo,
      {Phoenix.PubSub, [name: FindMyLocator.PubSub, adapter: Phoenix.PubSub.PG2]},
      FindMyLocatorWeb.Endpoint,
      {TelemetryUI, FindMyLocator.TelemetryUI.config()}
    ]

    :logger.add_handler(:sentry_handler, Sentry.LoggerHandler, %{})

    opts = [strategy: :one_for_one, name: FindMyLocator.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    FindMyLocatorWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
