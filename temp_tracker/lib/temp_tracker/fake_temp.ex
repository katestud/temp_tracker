defmodule TempTracker.FakeTemp do
  use GenServer

  # Public API

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def read_temp do
    71.25
  end

  # GenServer API

  def init(_opts) do
    state = %{
      sensors: [],
      temperatures: %{}
    }

    {:ok, state}
  end

end
