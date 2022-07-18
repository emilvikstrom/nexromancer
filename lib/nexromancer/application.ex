defmodule Nexromancer.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Horde.Registry, [name: Nexromancer.Registry, keys: :unique]},
      {Horde.DynamicSupervisor, [name: Nexromancer.Supervisor, strategy: :one_for_one]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Nexromancer.Application.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
