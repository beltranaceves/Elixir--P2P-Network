defmodule P2P do
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
        IO.puts "Hola que tal"
        controller(state)

      {:stop} ->
        :discovery_server |> GenServer.call({:unregister_me, self()})
        IO.puts "Aaaa dormir"
        exit(:normal)
    end
  end

end
