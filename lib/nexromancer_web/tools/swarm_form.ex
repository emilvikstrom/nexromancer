defmodule NexromancerWeb.Tools.SwarmForm do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field(:id, :binary)
    field(:name, :string)
    field(:url, :string)
    field(:method, :string)
    field(:headers, :string)
    field(:body, :string)
    field(:number_of_workers, :string)
  end

  def new() do
    params = Map.put(%{}, :id, UUID.uuid4())

    %__MODULE__{}
    |> cast(params, [
      :id
    ])
  end

  def changeset(changeset, params) do
    changeset
    |> cast(params, [
      :name,
      :headers,
      :method,
      :url,
      :body,
      :number_of_workers
    ])
    # |> validate_required([:id, :name, :headers, :method, :url, :body, :number_of_workers])
    |> validate_body()
  end

  defp validate_body(changeset) do
    validate_change(changeset, :body, fn
      :body, value ->
        case Jason.decode(value) do
          {:ok, _} ->
            []

          {:error, _} ->
            [{:body, "body must be valid json"}]
        end

      _field, _value ->
        []
    end)
  end
end
