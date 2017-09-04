defmodule Calcium.Client.CEX do
  @moduledoc """

  CEX client
  """
  # use GenStage
  use WebSockex
  require Logger

  def start_link do
    cex_url = System.get_env("CEX_URL")
    WebSockex.start_link(cex_url, __MODULE__, {})
  end

  def auth_json do
    stamp = timestamp()
    %{"e" => "auth", "auth" => %{
        "key" => key(),
        "signature" => signature(stamp),
        "timestamp" => stamp
      }
    } |> Poison.encode!
  end

  def auth_request(pid) do
    Logger.info("Sending authorization request:")
    pid |> send_frame({:text, auth_json})
  end

  def send_frame(pid, {:text, msg} = frame) do
    Logger.info("Sending message: #{msg}")
    WebSockex.send_frame(pid, frame)
  end

  def handle_frame({type, json_msg}, state) do
    msg = Poison.decode!(json_msg)
    IO.puts "Received Message - Type: #{inspect type} -- Message: #{inspect msg}"
    {:ok, state}
  end

  defp user_id, do: System.get_env("CEX_USER_ID")
  defp key, do: System.get_env("CEX_KEY")
  defp secret, do: System.get_env("CEX_SECRET")
  defp timestamp, do: DateTime.utc_now |> DateTime.to_unix |> Integer.to_string
  defp signature(stamp) do
    stamped_key = stamp <> key
    signed_key = :crypto.hmac(:sha256, secret, stamped_key)
    Base.encode16(signed_key)
  end
end
