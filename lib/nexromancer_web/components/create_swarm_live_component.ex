defmodule NexromancerWeb.Components.CreateSwarmLiveComponent do
  use NexromancerWeb, :live_component

  alias NexromancerWeb.Tools.SwarmForm

  @allowed_methods ["GET", "POST", "PUT", "DELETE", "OPTIONS", "HEAD", "PATCH"]

  def mount(socket) do
    changeset = SwarmForm.new()

    {:ok,
     assign(socket,
       changeset: changeset,
       form: to_form(changeset),
       valid_json: true,
       allowed_methods: @allowed_methods
     )}
  end

  def handle_event("validate", %{"swarm_form" => swarm}, socket) do
    changeset = socket.assigns.changeset |> SwarmForm.changeset(swarm) |> IO.inspect()

    socket =
      changeset
      |> case do
        %Ecto.Changeset{valid?: false, errors: errors} ->
          validation_error(socket, errors)

        _changeset ->
          assign(socket, valid_json: true, error_msg: "", changeset: changeset)
      end

    {:noreply, assign(socket, form: to_form(changeset))}
  end

  def handle_event(
        "start-swarm",
        %{"swarm_form" => _swarm},
        %{assigns: %{valid_json: true, changeset: changeset}} = socket
      ) do
    Nexromancer.Swarm.raise(changeset)
    IO.inspect(socket, label: :success)
    {:noreply, socket}
  end

  def handle_event(
        "start-swarm",
        %{"swarm_form" => _swarm},
        socket
      ) do
    IO.inspect(socket, label: :failure)
    {:noreply, socket}
  end

  defp validation_error(socket, errors) do
    error_msg =
      for {field, {error, _}} <- errors, into: "" do
        "#{field} #{error}\n"
      end

    assign(socket, valid_json: false, error_msg: error_msg)
  end
end
