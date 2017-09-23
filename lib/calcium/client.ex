defmodule Calcium.Client do
  require Logger

  use GenServer
  alias Calcium.CEX

  def start_link do
    Logger.info('Starting client')
    {:ok, pid} = GenServer.start_link(__MODULE__, :ok, [])
    IO.inspect(pid)
    {:ok, cex_pid} = CEX.start_link(pid)
    IO.inspect(cex_pid)
    Logger.info('Got all pids')
    GenServer.cast(pid, {:listen, {:ok, %{"cex" => cex_pid}}})
    {:ok, pid}
  end

  def auth(pid) do
    Logger.info('Authorizing')
    GenServer.cast(pid, :auth)
    # CEX.auth_request(client_pid)
    # GenServer.cast(__MODULE__, {:create, cex_pid})
  end

  def handle_cast({:listen, cex_pid}, _) do
    Logger.info('Listening')
    {:noreply, cex_pid}
  end
  def handle_cast(:auth, {:ok, %{"cex" => cex_pid}} = state) do
    Logger.info("Casting authorizing")
    CEX.auth_request(cex_pid)
    {:noreply, state}
  end

  def responce(msg) do
    Logger.info(msg)
  end
end
