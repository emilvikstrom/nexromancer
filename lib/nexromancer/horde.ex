defmodule Nexromancer.Horde do
  use GenServer

  alias Nexromancer.Minion

  defstruct [:order, minions: []]

  @impl true
  def init(order) do
    {:ok, %__MODULE__{order: order}}
  end

  @impl true
  def handle_call({:create, no_of_minions}, _from, state) do
    new_minions = no_of_minions |> create_minions(state.order)
    {:reply, :ok, %__MODULE__{state | minions: [new_minions | state.minions]}}
  end

  def handle_call(:start, _from, state) do
    started_minions =
      state.minions
      |> Enum.reduce(0, fn pid, counter ->
        :ok = GenServer.call(pid, :start)
        counter + 1
      end)

    {:reply, started_minions, state}
  end

  def handle_call(:stop, _from, state) do
    stopped_minions =
      state.minions
      |> Enum.reduce(0, fn pid, counter ->
        :ok = GenServer.call(pid, :stop)
        counter + 1
      end)

    {:reply, stopped_minions, state}
  end

  defp create_minions(amount, order), do: for(_ <- 1..amount, do: create_minion(order))

  defp create_minion(order) do
    {:ok, pid} = Minion.start(order)
    pid
  end
end
