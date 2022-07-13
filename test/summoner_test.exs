defmodule Nexromancer.SummonerTest do
  use ExUnit.Case
  alias Nexromancer.Summoner

  describe "spawn/1" do
    test "creates N processes and gets message back" do
      minions = Summoner.spawn(5)
      assert length(minions) == 5

      for pid <- minions do
        assert is_pid(pid)
      end

      assert minions |> assert_recv_all()
    end
  end

  defp assert_recv_all([]), do: true

  defp assert_recv_all(minions) do
    receive do
      {:hello, pid} ->
        minions
        |> List.delete(pid)
        |> assert_recv_all()
    after
      200 -> false
    end
  end
end
