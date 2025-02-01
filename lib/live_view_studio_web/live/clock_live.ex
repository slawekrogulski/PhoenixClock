defmodule LiveViewStudioWeb.ClockLive do
  use LiveViewStudioWeb, :live_view

  on_mount {LiveViewStudioWeb.Hooks.LocalTimeZoneHook, :default}

  @timer_interval :timer.seconds(1)

  @display_chars1 "0️⃣1️⃣2️⃣3️⃣4️⃣5️⃣6️⃣7️⃣8️⃣9️⃣"
  # @display_chars2 "𝟘𝟙𝟚𝟛𝟜𝟝𝟞𝟟𝟠𝟡"
  # @display_chars3 "𝟶𝟷𝟸𝟹𝟺𝟻𝟼𝟽𝟾𝟿"
  # @display_chars4 "𝟬𝟭𝟮𝟯𝟰𝟱𝟲𝟳𝟴𝟵"
  # @display_chars6 "𝟢𝟣𝟤𝟥𝟦𝟧𝟨𝟩𝟪𝟫"
  # @display_chars7 "𝟎𝟏𝟐𝟑𝟒𝟓𝟔𝟕𝟖𝟗"
  # @display_chars8 "⓪①②③④⑤⑥⑦⑧⑨"
  # @display_chars9 "⓪🂲②③④⑤⑥⑦⑧⑨"

  # @space0 "☺☻"
  # @space01 "∴∵"
  # @space02 "⊕⊗"
  # @space03 "⊞⊠"
  @space033 "♡♥"
  # @space04 "⊞⊡⊠⊡"
  # @space05 "⌍⌏⌎⌌"
  # @space06 "⌝⌟⌞⌜"
  # @space07 "┓┛┗┏"
  # @space08 "╀┾╁┽"
  # @space09 "┣┳┫┻"
  # @space1 ": : "
  # @space10 "╔╗╝╚"
  # @space11 "╩╠╦╣"
  # @space12 "╕╛╘╒"
  # @space13 "╖╜╙╓"
  # @space14 "╮╯╰╭"
  # @space15 "◥◢◣◤"
  # @space16 "▁▂▃▄▅▆▇█▇▆▅▄▃▂▁"
  # @space17 "◝◞◟◜"
  # @space2 "-\\|/"
  # @space3 "≑≒≑≓"
  # @space4 "⇗⇘⇙⇖"
  # @space5 "⇡⇢⇣⇠"
  # @space6 "⇡⇗⇢⇘⇣⇙⇠⇖"
  # @space7 "↑↗→↘↓↙←↖"
  # @space8 "▲►▼◄"

  @day_names_english  %{1 => "MonDay",       2 => "TuesDay", 3 => "WednesDay", 4 => "ThursDay", 5 => "FriDay", 6 => "SaturDay", 7 => "SunDay"}
  @day_names_polish   %{1 => "Poniedziałek", 2 => "Wtorek",  3 => "Środa",     4 => "Czwartek", 5 => "Piątek", 6 => "Sobota",   7 => "Niedziela"}
  @day_names_malay    %{1 => "Isnin",        2 => "Selasa",  3 => "Rabu",      4 => "Khamis",   5 => "Jumaat", 6 => "Sabtu",    7 => "Ahad"}
  @day_names_japanese %{1 => "月曜日",        2 => "火曜日",   3 => "水曜日",      4 => "木曜日",    5 => "金曜日",  6 => "土曜日",    7 => "日曜日"}
  @day_names %{
    0 => @day_names_english,
    1 => @day_names_polish,
    2 => @day_names_malay,
    3 => @day_names_japanese
  }
  @day_names_count @day_names |> Kernel.map_size()

  def mount(_params, _session, socket) do
    timer_ref = if connected?(socket) do
      {:ok, timer_ref} = :timer.send_interval(@timer_interval, self(), :tick)
      local_time_zone(socket.assigns)
      timer_ref
    else
      nil
    end

    current_datetime = Timex.now("Asia/Singapore")
    socket
    |> assign_current_time(current_datetime)
    |> assign_day_name(current_datetime)
    |> assign_sounds()
    |> assign(last_chime_hr: "")
    |> assign(timer_ref: timer_ref)
    |> ok()
  end

  # {@icon_name}
  # <.icon class="h-12 w-12" name={@icon_name}}/>
  def render(assigns) do
    ~H"""
    <div id="s" phx-hook="AudioMp3" data-sounds={@sounds} >
    <%!-- <div id="s" phx-hook="LocalTimeZone" data-sounds={@sounds} > --%>
      <body >
        <div id="clock">
          <%=@h1%><%=@h2%><%=@sp%><%=@m1%><%=@m2%>
        </div>
        <div id="day_name">
          <%= @day_name %>
        </div>
      </body>
    </div>
    """
  end

  defp assign_sounds(socket) do
    json =
      # https://opengameart.org/content/16-button-clicks
      Jason.encode!(%{
        # "button02" - edited version
        click: ~p"/audio/button-click.mp3",
        # "clic03" - edited, took (2nd part)
        donk: ~p"/audio/button-no-click.mp3",
        # https://opengameart.org/content/fantasy-sound-effects-library
        win: ~p"/audio/Jingle_Win_00.mp3",
        cuckoo: ~p"/audio/Cuckoo.mp3",
        chime_3s: ~p"/audio/chime-c-sharp-3s.mp3",
        tubular_1_5s: ~p"/audio/phased-tubular-bell-1_5s.mp3",
        noon_midnight: ~p"/audio/ticking-and-12-chime-of-an-old-junghans-wall-clock-27215.mp3"
      })

    assign(socket, :sounds, json)
  end

  def handle_event("local-timezone",  %{"local_timezone" => local_timezone}, socket) do
    IO.inspect(local_timezone, label: "!! local time zone")
    socket |>
    assign(local_timezone: local_timezone)
    |> noreply()
  end

  def handle_info(:tick, socket) do
    # IO.inspect(socket.assigns, label: "assigns")
    local_timezone = Map.get(socket.assigns, :local_timezone, "Asia/Singapore")
    current_datetime = Timex.now(local_timezone)
    #  local_time_zone(socket.assigns)
    # current_datetime = Timex.local()
    socket
    |> assign_current_time(current_datetime)
    |> assign_day_name(current_datetime)
    |> play_chime(current_datetime)
    |> noreply()
  end

  defp assign_day_name(socket, current_datetime) do
    minute = current_datetime |> Timex.format!("{m}") |> String.to_integer()
    day_name = current_datetime |> Timex.weekday!() |> get_day_name(minute)
    socket
    |> assign(day_name: day_name)
  end

  defp get_day_name(day_number, minute) do
    day_names = Map.get(@day_names, rem(minute, @day_names_count))
    Map.get(day_names, day_number)
  end

  def local_time_zone(%{local_timezone: local_timezone}) do
    IO.inspect(local_timezone, label: "local time zone:")
  end
  def local_time_zone(_assigns) do
    IO.inspect("unknown", label: "local time zone")
  end

  defp assign_current_time(socket, current_datetime) do
    # Format the DateTime
    <<h1, h2, m1, m2, s1, s2>> = current_datetime |> Timex.format!("{h24}{0m}{0s}")
    socket
    |> assign(h1: h1 |> number_as_emoji())
    |> assign(h2: h2 |> number_as_emoji())
    |> assign(m1: m1 |> number_as_emoji())
    |> assign(m2: m2 |> number_as_emoji())
    |> assign(icon_name: icon(s2, s1))
    |> assign(sp: spacer(s1, s2))
  end

  defp play_chime(socket, current_datetime) do
    time = current_datetime |> Timex.format!("{0m}{0s}")
    hr = current_datetime |> Timex.format!("{h24}")
    # hr = current_datetime |> Timex.format!("{0m}")
    if (time >= "0000" and time <= "0001" and socket.assigns.last_chime_hr != hr) do
      # IO.inspect(current_datetime, label: "current_datetime")
      hours = current_datetime |> Timex.format!("{h24}") |> String.to_integer()
      socket
      |> assign(last_chime_hr: hr)
      |> push_event("play-sound", play_sound_data(hours))
    else
      # d = %{
      #   time: time, hr: hr, last_hr: socket.assigns.last_chime_hr
      # }
      # IO.inspect(d)
      socket
    end
  end

  defp play_sound_data(n) when n in [0, 12]   , do: %{name: "noon_midnight", count: 1}
  defp play_sound_data(n) when rem(n, 2) == 0 , do: %{name: "chime_3s"     , count: chime_count(n)}
  defp play_sound_data(n)                     , do: %{name: "tubular_1_5s" , count: chime_count(n)}

  defp chime_count(h) when h > 12, do: h - 12
  defp chime_count(h)            , do: h

  @icons %{
    0 => "arrows-pointing-in",
    1 => "arrows-pointing-out",
    2 => "right",
    3 => "up",
    4 => "",
    5 => "",
    6 => "",
    7 => ""
  }

  defp icon(s1, s2) do
    seconds = fromDigits(s1, s2)
    # i = %{}
    # |> Map.put(0, "up")
    # |> Map.put(1, "up-right")
    # |> Map.put(2, "right")
    # |> Map.put(3, "down-right")
    # |> Map.put(4, "down")
    # |> Map.put(5, "down-left")
    # |> Map.put(6, "left")
    # |> Map.put(7, "up-left")


    "hero-" <> Map.get(@icons, rem(seconds, 2), "")
  end
  defp spacer(s1, s2), do: String.at(@space033, rem(fromDigits(s1, s2), 2))
  # defp spacer(s1, s2), do: String.at(@space16, rem(fromDigits(s1, s2), 15))

  defp fromDigits(n1, n2), do: (n1 - 48) * 10 + (n2 - 48)

  defp number_as_emoji(n) when n in 48..58, do: String.at(@display_chars1, (n - 48))
  defp number_as_emoji(_),                  do: "?"
end
