defmodule TempTrackerFwTest do
  use ExUnit.Case
  doctest TempTrackerFw

  test "greets the world" do
    assert TempTrackerFw.hello() == :world
  end
end
