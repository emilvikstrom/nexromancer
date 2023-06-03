defmodule NexromancerWeb.RootLive do
  use NexromancerWeb, :live_view

  alias Nexromancer.Swarm

  defmodule State do
    defstruct swarms: [],
              create_swarm: false
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, state: %__MODULE__.State{})}
  end

  def handle_event("create-swarm", _, socket) do
    {:noreply, assign(socket, state: socket.assigns.state |> set_create_swarm(true))}
  end

  defp add_swarm_to_state(%State{swarms: swarms} = state) do
    %State{state | swarms: [%Swarm{id: 1, name: "test", workers: [1, 2, 3]} | swarms]}
  end

  defp set_create_swarm(state, boolean) do
    %State{state | create_swarm: boolean}
  end
end
