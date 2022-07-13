defmodule Nexromancer.Minion do
  defmodule __MODULE__.Order do
    defstruct [:url, :method, :headers, :body, :type]
  end

  use GenServer

  @impl true
  def init([]) do
    {:ok, %{}}
  end

  @impl true
  def handle_call(%__MODULE__.Order{method: :get} = order, _from, state) do
    HTTPoison.get()
    {:reply, :ok, state}
  end
end
