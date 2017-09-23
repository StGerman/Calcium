defmodule Calcium do
  @moduledoc """

  Calcium application
  """
  use Application

  alias Calcium.Client
  import Supervisor.Spec

  def start(_type, _args) do
    children = [
      worker(Calcium.Client)
    ]
    {:ok, _} = Calcium.Supervisor.start_link()
  end

  def main do
    {:ok, client_pid} = Client.start_link()
    Client.auth(client_pid)
    # Process.sleep 200000
  end
end
