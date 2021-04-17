defmodule P2P.DiscoveryServer do
  @moduledoc """
  Documentation for `P2P`.
  """
  use GenServer

  # Client
    def start_link() do 
        GenServer.start_link(__MODULE__, :ok, [name: :discovery_server])
    end

  def stop() do
    pid = GenServer.whereis(__MODULE__)
    send(pid, :kill_me)
  end

  def crash() do
    pid = GenServer.whereis(__MODULE__)
    Process.exit(pid, :kill)
  end

  # Server

  def init(:ok) do
    {:ok, %{}}
  end

  def handle_info(:kill_me, state) do
    {:stop, :normal, state}
  end

  def handle_call({:register_me, pid}, _from, state) do
    {new_state, atom} = register_player(pid, 0, state)
    {:reply, atom, new_state}
  end

  def handle_call({:unregister_me, pid}, _from, state) do
    new_state = unregister_player(pid, state)
    {:noreply, new_state}
  end

  def handle_call({:list_players}, _from, state) do
    player_list = state |> Map.keys
    {:reply, player_list, state}
  end

  defp register_player(pid, n, state) do
    atom_string = "atom" <> Integer.to_string(n)
    atom = String.to_atom(atom_string)
    if !Process.whereis(atom) do
      Process.register(pid, atom)
      new_state = state |> Map.put(atom, pid)
      {new_state, atom}
    else
      register_player(pid, n + 1, state)
    end
  end


  defp unregister_player(pid, state) do
    {_, registered_name} = Process.info(pid, :registered_name)
    Process.unregister(registered_name)
    {_, new_state} = state |> Map.pop(registered_name)
    new_state
  end
end
