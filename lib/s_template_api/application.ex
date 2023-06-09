defmodule STemplateAPI.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      STemplateAPIWeb.Telemetry,
      # Start the Ecto repository
      STemplateAPI.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: STemplateAPI.PubSub},
      # Start the Endpoint (http/https)
      STemplateAPIWeb.Endpoint,
      # Start a worker by calling: STemplateAPI.Worker.start_link(arg)
      # {STemplateAPI.Worker, arg}
      Cache.LabelsCache
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: STemplateAPI.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    STemplateAPIWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
