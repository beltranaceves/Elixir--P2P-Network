defmodule P2P.Node do
  @moduledoc """
  Documentation for `P2P`.
  """
  def start() do
    pid = spawn(P2P, :controller, [%{}])
    :discovery_server |> GenServer.call({:register_me, pid})
  end

  def send_to_player(player, flag, content) do
    send(player, {flag, content})
  end

  @doc false
  def controller(state) do
    receive do
      {:exit_me} ->
        controller(state)

      {:stop} ->
        :discovery_server |> GenServer.call({:unregister_me, self()})
        exit(:normal)
    end
  end

end
