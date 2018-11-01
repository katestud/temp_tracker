defmodule TempTrackerTest do
  use ExUnit.Case
  doctest TempTracker

  test "greets the world" do
    assert TempTracker.hello() == :world
  end
end
