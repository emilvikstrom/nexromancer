defmodule Nexromancer.Swarm do
  defstruct [:id, :name, :url, :method, :headers, :body, workers: []]

  def raise(changeset) do
    IO.inspect(changeset)
  end
end
