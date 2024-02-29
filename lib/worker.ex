defmodule Worker do
  use GenServer

  require Logger
  require Redix

  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def init(_args) do
    {:ok, %{deadline: 0, loops_done: 0}}
  end

  def handle_info(:work, state) do
    interval = 1
    now = :os.system_time()

    if now > state.deadline do
      Logger.info("#{state.loops_done} units of work done, updating hash counter")

      Redix.command(:redix, ["INCRBY", "hashes", state.loops_done])

      new_state = %{state | loops_done: 0, deadline: now + interval * 1_000}

      {:noreply, new_state}
    else
      work_once()
      new_state = %{state | loops_done: state.loops_done + 1}

      {:noreply, new_state}
    end
  end

  defp work_once() do
    Logger.debug("Doing one unit of work")

    :timer.sleep(100)

    random_bytes = get_random_bytes()
    hex_hash = hash_bytes(random_bytes)

    if String.starts_with?(hex_hash, "0") do
      Logger.info("Coin found: #{String.slice(hex_hash, 0..7)}...")

      {:ok, created} = Redix.command(:redix, ["HSET", hex_hash, random_bytes])

      if !created do
        Logger.info("We already had that coin")
      end
    else
      Logger.debug("No coin found")
    end
  end

  defp get_random_bytes() do
    {:ok, response} = Req.get("http://rng/32")

    response.body
  end

  defp hash_bytes(data) do
    {:ok, response} =
      Req.post(
        "http://hasher/",
        body: data,
        headers: [
          %{"Content-Type" => ["application/octet-stream"]}
        ]
      )

    response.body
  end
end
