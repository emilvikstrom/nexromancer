defmodule Nexromancer.Minion do
  defmodule __MODULE__.Order do
    defstruct [:url, :method, :headers, :body, :type, :expectation]

    defmodule __MODULE__.Expectation do
      defstruct [:status, :body, :headers]
    end

    defmodule __MODULE__.Type do
      defstruct [:type, options: []]
    end
  end

  use GenServer

  @impl true
  def init([]) do
    {:ok, %{state: :idle}}
  end

  @impl true
  def handle_call(%__MODULE__.Order{} = order, _from, state)
      when order.url != nil and order.method != nil do
    Process.send_after(self(), order, 500)

    HTTPoison.get!(order.url)
    |> IO.inspect()

    {:reply, :ok, %{state | state: :running}}
  end

  def handle_call(:stop, _from, %{state: :running}) do
    {:reply, :ok, %{state: :idle}}
  end

  @impl true
  def handle_info(%__MODULE__Order{url: url, method: :get} = order, %{state: :running} = state) do
    HTTPoison.get!(url) |> IO.inspect()
    Process.send_after(self(), order, 500)

    {:noreply, state}
  end

  def handle_info(_, %{state: :idle} = state) do
    {:noreply, state}
  end
end
