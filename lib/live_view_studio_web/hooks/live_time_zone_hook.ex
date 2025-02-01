defmodule LiveViewStudioWeb.Hooks.LocalTimeZoneHook do
  @moduledoc false
  # import Phoenix.LiveView
  use Phoenix.LiveView
  # use LiveViewStudioWeb, :live_view

  def render(assigns) do
    ~H"""
    <div id="local-timezone" phx-hook="LocalTimeZoneHook" phx-update="ignore">
      <%= @local_timezone %>
    </div>
    """
  end
  def on_mount(:default, _params, _session, socket) do
    {:cont,
      socket
      |> attach_hook(:local_tz, :handle_event, fn
        "local-timezone", %{"local-timezone" => local_timezone},
          socket ->
            # Handle our "local-timezone" event and detach hook
            socket =
              socket
              |> assign(:local_timezone, local_timezone)
            {:halt, detach_hook(socket, :local_tz, :handle_event)}
        _event, _params, socket ->
          {:cont, socket}
      end)
    }
  end
end
