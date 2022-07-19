defmodule Nexromancer.MinionTest do
  use ExUnit.Case
  import ExUnit.CaptureLog
  import Hammox

  alias Nexromancer.Minion

  setup :verify_on_exit!
  setup :set_mox_global

  setup do
    {:ok, order: Nexromancer.Order.new("http://test", :get)}
  end

  describe "start and stop" do
    test "successfully start and stop a Minion", %{order: order} do
      assert {:ok, pid} = Minion.start(order)
      assert :ok = Minion.stop(pid)
    end
  end

  describe "execute an order" do
    test "without expectation", %{order: order} do
      HTTPMock
      |> expect(:get!, fn url ->
        %HTTPoison.Response{request: %HTTPoison.Request{url: url}, status_code: 200}
      end)

      {:ok, pid} = Minion.start(order, 10, HTTPMock)

      assert capture_log(fn ->
               assert :ok = Minion.run(pid)
               assert :ok = Minion.idle(pid)
             end) =~ "Got 200"

      :ok = Minion.stop(pid)
    end

    test "with expectation", %{order: order} do
      HTTPMock
      |> expect(:get!, fn url ->
        %HTTPoison.Response{request: %HTTPoison.Request{url: url}, status_code: 200}
      end)
      |> expect(:get!, fn url ->
        %HTTPoison.Response{request: %HTTPoison.Request{url: url}, status_code: 400}
      end)

      {:ok, pid} =
        order
        |> Nexromancer.Order.add_expectation(200)
        |> Minion.start(5, HTTPMock)

      log =
        capture_log(fn ->
          assert :ok = Minion.run(pid)
          Process.sleep(10)
          assert :ok = Minion.idle(pid)
        end)

      assert log =~ "OK"
      assert log =~ "Expected 200 got 400"

      :ok = Minion.stop(pid)
    end
  end
end
