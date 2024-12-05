defmodule Bingo.BingoSupervisor do
  use Supervisor

  def start_link(_args) do
    IO.puts "Starting THE #{__MODULE__}..."
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    children = [
      Bingo.BingoServer,
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

  def handle_info(msg, _state) do
    IO.inspect(msg, label: "sup")
  end
end
