defmodule Nexromancer.Swarm do
  defstruct [:id, :name, :url, :method, :headers, :body, workers: []]

  def raise(%Ecto.Changeset{
        valid?: true,
        changes: changes,
        data: %NexromancerWeb.Tools.SwarmForm{}
      }) do
    Enum.reduce(changes, %__MODULE__{}, fn
      {:id, id}, acc ->
        Map.put(acc, :id, id)

      {:name, name}, acc ->
        Map.put(acc, :name, name)

      {:url, url}, acc ->
        Map.put(acc, :url, url)

      {:method, method}, acc ->
        Map.put(acc, :url, method)

      {:headers, headers}, acc ->
        Map.put(acc, :headers, headers)

      {:body, body}, acc ->
        Map.put(acc, :body, body)

      {:number_of_workers, workers}, acc ->
        w = String.to_integer(workers)
        Map.put(acc, :workers, create_worker(w))
    end)
  end

  # TODO Fix actual implementation

  def create_worker(amount) do
    for worker <- 1..amount do
      worker
    end
  end
end
