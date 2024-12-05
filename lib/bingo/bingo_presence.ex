defmodule Bingo.BingoPresence do
  alias LiveViewStudio.Accounts.User
  alias LiveViewStudioWeb.Presence
  @topic "users:bingo"

  @pubsub LiveViewStudio.PubSub

  def subscribe() do
    Presence.subscribe(@topic)
    # Phoenix.PubSub.subscribe(@pubsub, @topic)
  end

  def track_user(%User{id: id}, meta), do: Presence.track(self(), @topic, id, meta)
  def track_user(nil,           meta), do: Presence.track(self(), @topic, :bingo_server, meta)

  def broadcast(msg) do
    Phoenix.PubSub.broadcast(@pubsub, @topic, msg)
  end

end
