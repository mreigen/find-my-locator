defmodule FindMyLocator.Mixfile do
  use Mix.Project

  def project do
    [
      app: :find_my_locator,
      version: "0.0.1",
      erlang: "~> 25.0",
      elixir: "~> 1.13",
      elixirc_paths: elixirc_paths(Mix.env()),
      test_paths: ["test"],
      test_pattern: "**/*_test.exs",
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [coveralls: :test, "coveralls.detail": :test, "coveralls.post": :test, "coveralls.html": :test],
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      dialyzer: dialyzer(),
      releases: releases()
    ]
  end

  def application do
    [
      mod: {FindMyLocator.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp aliases do
    [
      "assets.deploy": [
        "esbuild default --minify",
        "phx.digest"
      ],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end

  defp deps do
    [
      # Assets bundling
      {:esbuild, "~> 0.7", runtime: Mix.env() == :dev},

      # HTTP Client
      {:hackney, "~> 1.18"},

      # HTTP server
      {:plug_cowboy, "~> 2.6"},
      {:plug_canonical_host, "~> 2.0"},
      {:corsica, "~> 2.1"},

      # Phoenix
      {:phoenix, "~> 1.7"},
      {:phoenix_html, "~> 3.3"},
      {:phoenix_live_view, "~> 0.19"},
      {:phoenix_ecto, "~> 4.4"},
      {:phoenix_live_reload, "~> 1.4", only: :dev},
      {:jason, "~> 1.4"},

      # GraphQL
      {:absinthe, "~> 1.7"},
      {:absinthe_security, "~> 0.1"},
      {:absinthe_plug, "~> 1.5"},
      {:dataloader, "~> 2.0"},
      {:absinthe_error_payload, "~> 1.1"},

      # Database
      {:ecto_sql, "~> 3.10"},
      {:postgrex, "~> 0.17"},

      # Database check
      {:excellent_migrations, "~> 0.1", only: [:dev, :test], runtime: false},

      # Translations
      {:gettext, "~> 0.22"},

      # Errors
      {:sentry, "~> 9.1"},

      # Monitoring
      {:new_relic_agent, "~> 1.27"},
      {:new_relic_absinthe, "~> 0.0"},

      # Telemetry
      {:telemetry_ui, "~> 4.0"},

      # Linting
      {:credo, "~> 1.7", only: [:dev, :test], override: true},
      {:credo_envvar, "~> 0.1", only: [:dev, :test], runtime: false},
      {:credo_naming, "~> 2.0", only: [:dev, :test], runtime: false},
      {:styler, "~> 0.10", only: [:dev, :test], runtime: false},

      # Security check
      {:sobelow, "~> 0.12", only: [:dev, :test], runtime: true},
      {:mix_audit, "~> 2.1", only: [:dev, :test], runtime: false},

      # Health
      {:plug_checkup, "~> 0.6"},

      # Test factories
      {:ex_machina, "~> 2.7", only: :test},
      {:faker, "~> 0.17", only: :test},

      # Test coverage
      {:excoveralls, "~> 0.16", only: :test},

      # Dialyzer
      {:dialyxir, "~> 1.3", only: [:dev, :test], runtime: false}
    ]
  end

  defp dialyzer do
    [
      plt_file: {:no_warn, "priv/plts/find_my_locator.plt"},
      plt_add_apps: [:mix, :ex_unit]
    ]
  end

  defp releases do
    [
      find_my_locator: [
        version: {:from_app, :find_my_locator},
        applications: [find_my_locator: :permanent],
        include_executables_for: [:unix],
        steps: [:assemble, :tar]
      ]
    ]
  end
end
