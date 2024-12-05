defmodule LiveViewStudioWeb.Presence do
  @moduledoc """
  Provides presence tracking to channels and processes.

  See the [`Phoenix.Presence`](https://hexdocs.pm/phoenix/Phoenix.Presence.html)
  docs for more details.
  """

  alias LiveViewStudio.Accounts.User

  use Phoenix.Presence,
    otp_app: :live_view_studio,
    pubsub_server: LiveViewStudio.PubSub

  def subscribe(topic), do: Phoenix.PubSub.subscribe(LiveViewStudio.PubSub, topic)

  def track_user(%User{id: id}, topic, meta), do: track(self(), topic, id, meta)

  def list_users(topic), do: list(topic) |> simple_presence_map()

  defp simple_presence_map(presences) do
    presences
    |> Enum.into(%{}, fn {user_id, metas} -> {user_id, get_first_meta(metas)} end)
  end

  defp get_first_meta(%{metas: [meta | _]}), do: meta

  def update_user(%User{id: id}, topic, meta), do: update(self(), topic, id, meta)

  def get_user_presence(%User{id: id}, topic), do: get_by_key(topic, id)
  def get_user_presence_meta(%User{id: _id} = user, topic), do: get_user_presence(user, topic) |> get_first_meta()

  def handle_diff(socket, diff) do
    socket
    |> Phoenix.Component.update(:presences, &update_presences(&1, diff))
  end

  defp update_presences(presences, diff) do
    presences
    |> Map.drop(Map.keys(diff.leaves))
    |> Map.merge(simple_presence_map(diff.joins))
  end

end
