defmodule LocolBackend.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      LocolBackendWeb.Telemetry,
      LocolBackend.Repo,
      {DNSCluster, query: Application.get_env(:locol_backend, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: LocolBackend.PubSub},
      # Start a worker by calling: LocolBackend.Worker.start_link(arg)
      # {LocolBackend.Worker, arg},
      # Start to serve requests, typically the last entry
      LocolBackendWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: LocolBackend.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    LocolBackendWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
