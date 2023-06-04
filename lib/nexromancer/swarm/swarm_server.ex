defmodule Nexromancer.Swarm.SwarmServer do
  use GenServer
  alias Nexromancer.Swarm

  defmodule State do
    defstruct [
      :swarm,
      state: :stopped
    ]
  end

  def init([%Swarm{} = swarm]) do
    {:ok, %__MODULE__.State{swarm: swarm}}
  end
end
