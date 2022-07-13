defmodule Nexromancer.Summoner do
  def spawn(no_to_spawn) do
    parent_pid = self()

    for _ <- 1..no_to_spawn do
      Kernel.spawn(fn ->
        send(parent_pid, {:hello, self()})
      end)
    end
  end
end
