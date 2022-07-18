defmodule Nexromancer.MinionTest do
  use ExUnit.Case
  import Hammox

  alias Nexromancer.Minion

  setup :verify_on_exit!
  setup :set_mox_global

  setup do
    {:ok, order: %Nexromancer.Horde.Order{method: :get, url: "http://test"}}
  end

  describe "start and stop" do
    test "successfully start and stop a Minion", %{order: order} do
      assert {:ok, pid} = Minion.start(order)
      assert :ok = Minion.stop(pid)
    end
  end

  test "start sending order", %{order: order} do
    HTTPMock
    |> expect(:get!, fn url ->
      %HTTPoison.Response{request: %HTTPoison.Request{url: url}, status_code: 200}
    end)

    {:ok, pid} = Minion.start(order, HTTPMock)
    assert :ok = Minion.run(pid)
    assert :ok = Minion.idle(pid)
    :ok = Minion.stop(pid)
  end
end
