defmodule Bingo.BingoServer do
alias Bingo.BingoPresence

  use GenServer

  use LiveViewStudio, :genserver

  @name :bingo_server
  @timer_interval :timer.seconds(1)

  defmodule State do
    defstruct numbers: [],
              timer_ref: nil,
              num_players: 0
  end

  def start_link(_args) do
    IO.puts "Starting #{@name}..."
    GenServer.start_link(__MODULE__, %State{}, name: @name)
  end

  def init(init_arg) do
    BingoPresence.subscribe()
    # BingoPresence.track_user(nil, %{})

    # IO.inspect(__ENV__, label: "__ENV__")
    init_arg
    # |> IO.inspect(label: "#{__MODULE__}.#{elem(__ENV__.function, 0)}.init_arg")
    # |> IO.inspect(label: "#{__MODULE__}.#{elem(__ENV__.function, 0)}.init_arg")
    |> ok()
  end

  def handle_info(:tick, state) do
    # IO.inspect("tick")
    state
    |> pick_number()
    |> send_number()
    |> noreply()
  end

  def handle_info(%{event: "presence_diff", payload: diff}, %State{} = state) do
    # IO.inspect(state, label: "handle_info.presence_diff.state")
    # IO.inspect(diff, label: "diff")
    %{joins: joins, leaves: leaves} = diff
    # IO.inspect(diff, label: "BingoServer.presence_diff")
    joins = Enum.count(joins)
    # |> IO.inspect(label: "joins")
    leaves = Enum.count(leaves)
    # |> IO.inspect(label: "leaves")
    state
    |> Map.update(:num_players, 0, &(&1 + joins - leaves))
    # |> IO.inspect(label: "state")
    |> start_game_if_minimum_players()
    |> noreply()
  end

  def handle_info({:num, _num}, state), do: state |> noreply()
  # def handle_info(msg, state) do
  #   IO.inspect(msg, label: "BingoServer received")
  #   state |> noreply()
  # end

  def start_game_if_minimum_players(%State{num_players: 2, timer_ref: nil} = state) do
    IO.inspect(2, label: "starting game, num_players")
    {:ok, timer_ref} = :timer.send_interval(@timer_interval, self(), :tick)
    state
    |> Map.put(:numbers, all_numbers())
    |> Map.put(:timer_ref, timer_ref)
  end
  def start_game_if_minimum_players(%State{num_players: num_players, timer_ref: nil} = state) when num_players < 2 do
    IO.inspect(num_players, label: "not enough players top start game, num_players")
    state
  end
  def start_game_if_minimum_players(%State{num_players: 1, timer_ref: timer_ref} = state) do
    IO.inspect(1, label: "not enough players to continue playing, num_players")
    {:ok, :cancel} = :timer.cancel(timer_ref)
    state
    |> Map.put(:timer_ref, nil)
  end
  def start_game_if_minimum_players(%State{num_players: num_players, timer_ref: timer_ref} = state)
  when num_players > 1 and timer_ref != nil do
    IO.inspect(num_players, label: "continue playing, num_players")
    state
  end

  def all_numbers() do
    ~w(B I N G O)
    |> Enum.zip(Enum.chunk_every(1..75, 15))
    |> Enum.flat_map(fn {letter, numbers} ->
      Enum.map(numbers, &"#{letter} #{&1}")
    end)
    |> Enum.shuffle()
  end

  def pick_number(%State{numbers: []} = state),       do: {nil, state}
  def pick_number(%State{numbers: [x | []]} = state), do: {x, state |> Map.put(:numbers, [])}
  def pick_number(%State{numbers: [x | xs]} = state), do: {x, state |> Map.put(:numbers, xs)}

  def send_number({nil, %State{timer_ref: timer_ref} = state}) do
    {:ok, :cancel} = :timer.cancel(timer_ref)
    IO.inspect("*** no more numbers ***")
    state |> Map.put(:timer_ref, nil)
  end
  def send_number({num, state}) do
    BingoPresence.broadcast({:num, num})
    state
  end

end
