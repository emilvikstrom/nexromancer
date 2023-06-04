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
    {:noreply,
     assign(socket, state: socket.assigns.state |> set_create_swarm(true), root_pid: self())}
  end

  def handle_info({:add_swarm, %Swarm{} = swarm}, socket) do
    {:noreply,
     assign(socket,
       state:
         socket.assigns.state
         |> add_swarm_to_state(swarm)
         |> set_create_swarm(false)
     )}
  end

  defp add_swarm_to_state(%State{swarms: swarms} = state, swarm_to_add) do
    %State{state | swarms: [swarm_to_add | swarms]}
  end

  defp set_create_swarm(state, boolean) do
    %State{state | create_swarm: boolean}
  end
end
