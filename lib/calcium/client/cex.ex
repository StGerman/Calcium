defmodule Calcium.Client.CEX do
  use WebSockex
  require Logger

  @url     System.get_env("CEX_URL")
  @user_id System.get_env("CEX_USER_ID")
  @key     System.get_env("CEX_KEY")
  @secret  System.get_env("CEX_SECRET")

  def start_link do
    WebSockex.start_link(@url, __MODULE__, {})
  end

  def auth_json do
    %{"e" => "auth", "auth" => %{
        "key" => @key,
        "signature" => signature(),
        "timestamp" => timestamp()
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

  defp signature do
    :crypto.hmac(:sha256, "key", "The quick brown fox jumps over the lazy dog")
      |> Base.encode16
  end
  defp timestamp, do: DateTime.utc_now |> DateTime.to_unix

end
