defmodule LiveViewStudio.MixProject do
  use Mix.Project

  def project do
    [
      app: :live_view_studio,
      version: "0.2.0",
      elixir: "~> 1.20.5",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      listeners: [Phoenix.CodeReloader]
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {LiveViewStudio.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.8.16"},
      {:phoenix_html, "~> 4.4"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_live_view, "~> 1.2.13"},
      # {:heroicons,
      #  github: "tailwindlabs/heroicons",
      #  tag: "v2.1.1",
      #  sparse: "optimized",
      #  app: false,
      #  compile: false,
      #  depth: 1},
      {:heroicons, "~> 0.5.7"},
      {:floki, ">= 0.36.0", only: :test},
      {:phoenix_live_dashboard, "~> 0.8.7"},
      {:esbuild, "~> 0.8", runtime: Mix.env() == :dev},
      {:tailwind, "~> 0.2.0", runtime: Mix.env() == :dev},
      {:swoosh, "~> 1.29"},
      {:finch, "~> 0.24"},
      {:telemetry, "~> 1.4.1"},
      {:telemetry_metrics, "~> 1.1.0"},
      {:telemetry_poller, "~> 1.1.0"},
      {:gettext, "~> 0.26"},
      {:jason, "~> 1.4"},
      {:plug_cowboy, "~> 2.9.0"},
      {:bcrypt_elixir, "~> 3.2.1"},
      {:faker, "~> 0.19.0"},
      {:number, "~> 1.0.5"},
      {:timex, "~> 4.0.0"},
      {:typed_struct, "~> 0.3.0"},
      {:decimal, "~> 3.2", override: true},
      {:tzdata, "~> 1.1.5", override: true},
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "assets.setup", "assets.build"],
      "assets.setup": ["tailwind.install --if-missing", "esbuild.install --if-missing"],
      "assets.build": ["tailwind default", "esbuild default"],
      "assets.deploy": [
        "tailwind default --minify",
        "esbuild default --minify",
        "phx.digest"
      ]
      # setup: ["deps.get", "assets.setup", "assets.build"],
      # test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"],
      # "assets.setup": [
      #   "tailwind.install --if-missing",
      #   "esbuild.install --if-missing"
      # ],
      # "assets.build": [
      #   "tailwind default",
      #   "esbuild default"
      # ],
      # "assets.deploy": [
      #   "tailwind default --minify",
      #   "esbuild default --minify",
      #   "phx.digest"
      # ]
    ]
  end
end
