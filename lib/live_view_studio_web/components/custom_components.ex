defmodule LiveViewStudioWeb.CustomComponents do
  use Phoenix.Component

#   attr :expiration, :integer, default: 24
#   slot :legal
#   slot :inner_block, required: true
#   def promo(assigns) do
#     ~H"""
#     <div class="promo">
#       <div class="deal">
#         <%= render_slot(@inner_block) %>
#       </div>
#       <div class="expiration">
#         Deal expires in <%= @expiration %> hours
#       </div>
#       <div class="legal">
#          <%= render_slot(@legal) %>
#       </div>
#     </div>
#     """
#   end

#   attr :label, :string, required: true
#   attr :class, :string, default: nil
#   attr :rest, :global
#   def badge(assigns) do
#     ~H"""
#     <span
#       class={["inline-flex items-center gap-0.5 rounded-full
#             bg-gray-300 px-3 py-0.5 text-sm font-medium
#             text-gray-800 hover:cursor-pointer", @class]}
#             {@rest}>
#       <%= @label %>
#       <Heroicons.x_mark class="h-3 w-3 text-gray-600" />
#     </span>
#     """
#   end

#   attr :visible, :boolean, required: true
#   def loading_indicator(assigns) do
#     ~H"""
#     <%!-- <div :if={@visible} class="loader">Loading...</div> --%>
#     <div :if={@visible} class="flex justify-center my-10 relative">
#       <div class="w-12 h-12 rounded-full absolute border-8 border-gray-300"/>
#       <div class="w-12 h-12 rounded-full absolute border-8 border-indigo-400 border-t-transparent animate-spin"/>
#     </div>
#     """
#   end

end
