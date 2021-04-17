defmodule P2PTest do
  use ExUnit.Case
  doctest P2P

  test "greets the world" do
    assert P2P.hello() == :world
  end
end
