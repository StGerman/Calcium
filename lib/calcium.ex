defmodule Calcium do
  @moduledoc """

  Calcium application
  """

  alias Calcium.Client.CEX

  def main do
    {:ok, pid} = CEX.start_link()
    CEX.auth_request(pid)
  end
end
