defmodule Nexromancer.Horde do
  use GenServer

  alias Nexromancer.Minion

  defstruct [:order, size: 0, timer: 500, minions: [], http_client: HTTPoison]

  def start(order, timer, http_client) do
    GenServer.start(__MODULE__, [order, timer, http_client], [])
  end

  def start(order) do
    GenServer.start(__MODULE__, order, [])
  end

  def start_link(order, timer, http_client) do
    GenServer.start_link(__MODULE__, [order, timer, http_client], [])
  end

  def start_link(order) do
    GenServer.start_link(__MODULE__, order, [])
  end

  def start_horde(pid) do
    GenServer.call(pid, :start_horde)
  end

  def size(pid) do
    GenServer.call(pid, :size)
  end

  def create_minions(pid, no_of_minions) do
    GenServer.call(pid, {:create, no_of_minions})
  end

  @impl true
  def init([order, timer, http_client]) do
    {:ok, %__MODULE__{order: order, timer: timer, http_client: http_client}}
  end

  def init(order) do
    {:ok, %__MODULE__{order: order}}
  end

  @impl true
  def handle_call(:size, _from, horde) do
    {:reply, horde.size, horde}
  end

  def handle_call({:create, no_of_minions}, _from, horde) do
    new_minions = no_of_minions |> create_minions(horde.order, horde.http_client)

    {:reply, :ok,
     %__MODULE__{horde | minions: new_minions ++ horde.minions, size: horde.size + no_of_minions}}
  end

  def handle_call(:start_horde, _from, horde) do
    started_minions =
      horde.minions
      |> Enum.reduce(0, fn pid, counter ->
        :ok = GenServer.call(pid, :start)
        counter + 1
      end)

    {:reply, started_minions, horde}
  end

  def handle_call(:stop, _from, horde) do
    stopped_minions =
      horde.minions
      |> Enum.reduce(0, fn pid, counter ->
        :ok = GenServer.call(pid, :stop)
        counter + 1
      end)

    {:reply, stopped_minions, horde}
  end

  defp create_minions(amount, order, http_client),
    do: for(_ <- 1..amount, do: create_minion(order, 500, http_client))

  defp create_minion(order, _timer, http_client) do
    {:ok, pid} = Minion.start(order, 500, http_client)
    pid
  end
end
