defmodule Nexromancer.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    topologies = [
      example: [
        strategy: Cluster.Strategy.LocalEpmd
      ]
    ]

    children = [
      {Cluster.Supervisor, [topologies, [name: Nexromancer.ClusterSupervisor]]},
      {Horde.Registry, [name: Nexromancer.Registry, keys: :unique, members: :auto]},
      {Horde.DynamicSupervisor,
       [name: Nexromancer.Supervisor, strategy: :one_for_one, members: :auto]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Nexromancer.Application.Supervisor]
    supervisor_result = Supervisor.start_link(children, opts)

    Nexromancer.child_spec(name: Nexromancer)
    |> Nexromancer.Supervisor.start_child()

    Nexromancer.Scribe.child_spec()
    |> Nexromancer.Supervisor.start_child()

    supervisor_result
  end
end
