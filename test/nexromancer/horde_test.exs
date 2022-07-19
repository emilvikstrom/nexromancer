defmodule Nexromancer.HordeTest do
  use ExUnit.Case

  setup_all do
    order = %Nexromancer.Order{
      url: "http://test",
      method: :get
    }

    {:ok, pid} = GenServer.start(Nexromancer.Horde, order)

    {:ok, %{horde: pid}}
  end

  test "start 1 minion", %{horde: horde} do
    assert :ok = GenServer.call(horde, {:create, 1})
  end
end
