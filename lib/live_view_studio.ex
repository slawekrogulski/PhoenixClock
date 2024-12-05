defmodule LiveViewStudio do
  @moduledoc """
  LiveViewStudio keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  def genserver do
    quote do
      def ok(state), do: {:ok, state}
      def noreply(state), do: {:noreply, state}
    end
  end

    @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
