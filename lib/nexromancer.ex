defmodule Nexromancer do
  use GenServer
  require Logger
  defstruct hordes: []

  def create_horde(order) do
    via_tuple(__MODULE__)
    |> GenServer.call({:create_horde, order})
  end

  def create_minions(horde, amount) do
    via_tuple(__MODULE__)
    |> GenServer.cast({:spawn_minions, horde, amount})
  end

  def start_horde(horde) do
    via_tuple(__MODULE__)
    |> GenServer.cast({:start_horde, horde})
  end

  def get_state() do
    via_tuple(__MODULE__)
    |> GenServer.call(:get_state)
  end

  def child_spec() do
    %{
      id: "#{__MODULE__}_#{__MODULE__}",
      start: {__MODULE__, :start_link, [__MODULE__]},
      shutdown: 10_000,
      restart: :transient
    }
  end

  def start_link(name) do
    case GenServer.start_link(__MODULE__, [], name: via_tuple(name)) do
      {:ok, pid} ->
        {:ok, pid}

      {:error, {:already_started, pid}} ->
        Logger.info("already started at #{inspect(pid)}, returning :ignore")
        :ignore
    end
  end

  def init(_args) do
    {:ok, %__MODULE__{}}
  end

  def handle_call({:create_horde, order}, _from, nexromancer) do
    {:ok, new_horde} = Nexromancer.Horde.start_link(order)

    {:reply, :ok, %__MODULE__{nexromancer | hordes: [new_horde | nexromancer.hordes]}}
  end

  def handle_call(:get_state, _from, nexromancer) do
    {:reply, nexromancer, nexromancer}
  end

  def handle_cast({:spawn_minions, horde, amount}, nexromancer) do
    Nexromancer.Horde.create_minions(horde, amount)

    {:noreply, nexromancer}
  end

  def handle_cast({:start_horde, horde}, nexromancer) do
    Nexromancer.Horde.start_horde(horde)

    {:noreply, nexromancer}
  end

  def via_tuple(name), do: {:via, Horde.Registry, {Nexromancer.Registry, name}}
end
