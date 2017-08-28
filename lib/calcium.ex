defmodule Calcium do
  alias Calcium.Client.CEX

  def main do
    {:ok, pid} = CEX.start_link()
    CEX.auth_request(pid)
    Process.sleep 500
    CEX.send_frame(pid, {:text, %{}})
    Process.sleep 1500
  end
end
