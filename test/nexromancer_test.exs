defmodule NexromancerTest do
  use ExUnit.Case
  doctest Nexromancer

  test "greets the world" do
    assert Nexromancer.hello() == :world
  end
end
