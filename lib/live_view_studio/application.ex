defmodule LiveViewStudio.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      LiveViewStudioWeb.Telemetry,
      # Start the Ecto repository
      # LiveViewStudio.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: LiveViewStudio.PubSub},
      # Start Finch
      {Finch, name: LiveViewStudio.Finch},
      # Start the Endpoint (http/https)
      LiveViewStudioWeb.Endpoint
      # LiveViewStudioWeb.Presence
      # Start a worker by calling: LiveViewStudio.Worker.start_link(arg)
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: LiveViewStudio.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    LiveViewStudioWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
