defmodule Nexromancer.Scribe do
  use GenServer
  require Logger

  def log(message) do
    [{pid, _}] = via_tuple(__MODULE__) |> Horde.Registry.lookup()
    pid |> Kernel.send({:log, message})
  end

  def child_spec() do
    %{
      id: "#{__MODULE__}_scribe",
      start: {__MODULE__, :start_link, []},
      shutdown: 10_000,
      restart: :transient
    }
  end

  def start_link() do
    case GenServer.start_link(__MODULE__, [], name: via_tuple(__MODULE__)) do
      {:ok, pid} ->
        {:ok, pid}

      {:error, {:already_started, _pid}} ->
        :ignore
    end
  end

  def init(_args) do
    {:ok, nil}
  end

  def handle_info({:log, message}, state) do
    Logger.info(message)
    {:noreply, state}
  end

  def via_tuple(name), do: {:via, Horde.Registry, {Nexromancer.Registry, name}}
end
