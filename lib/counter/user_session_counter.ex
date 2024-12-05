defmodule Counter.UserSessionCounter do
  use Agent

  require Logger
  
  @name :user_session_counter

  def start_link(counter) do
    Logger.debug "#{__MODULE__}.start_link(counter=#{inspect counter})"
    Agent.start_link(fn -> counter end, name: @name)
  end

  def get do
    Agent.get @name, & &1
  end

  def inc() do
    Agent.update @name, &(&1 + 1)
  end

end
