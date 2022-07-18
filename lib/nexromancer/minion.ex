defmodule Nexromancer.Minion do
  use GenServer

  alias Nexromancer.Horde.Order

  defstruct [:http_client, :order, state: :idle, timer: 500]

  def start(%Order{} = order, http_client \\ HTTPoison) do
    GenServer.start(__MODULE__, [order, http_client])
  end

  def stop(pid) do
    GenServer.stop(pid)
  end

  def run(pid) do
    GenServer.call(pid, :start)
  end

  def idle(pid) do
    GenServer.call(pid, :stop)
  end

  @impl true
  def init([order, http_client]) do
    {:ok, %__MODULE__{order: order, http_client: http_client}}
  end

  @impl true
  def handle_call(:start, _from, state)
      when state.order.url != nil and state.order.method != nil do
    send(self(), :request)

    {:reply, :ok, %__MODULE__{state | state: :running}}
  end

  def handle_call(:stop, _from, %{state: :running}), do: {:reply, :ok, %{state: :idle}}

  @impl true
  def handle_info(:request, %{state: :running} = state) do
    Process.send_after(self(), :request, state.timer)
    perform(state.order, state.http_client)
    {:noreply, state}
  end

  def handle_info(_, %{state: :idle} = state) do
    {:noreply, state}
  end

  defp perform(%Order{} = order, http_client) do
    http_client.get!(order.url) |> IO.inspect()
  end
end
