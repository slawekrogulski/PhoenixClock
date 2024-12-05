defmodule Counter.UserSessionCounterSupervisor do
  use Supervisor

  require Logger

  def start_link(_arg) do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)

  end

  def init(_init_arg) do
    children = [
      {Counter.UserSessionCounter, 0}
    ]
    Supervisor.init(children, strategy: :one_for_one)
  end
end
