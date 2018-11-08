defmodule TempTracker.FakeTemp do
  use GenServer

  # Public API

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def read_temp do
    71.25
  end

  def recent_readings(_) do
    %{
      measurement_1_temp: 71.45,
      measurement_1_timestamp: DateTime.utc_now(),
      measurement_2_temp: 71.45,
      measurement_2_timestamp: DateTime.utc_now(),
      measurement_3_temp: 71.45,
      measurement_3_timestamp: DateTime.utc_now(),
      measurement_4_temp: 71.45,
      measurement_4_timestamp: DateTime.utc_now(),
      measurement_5_temp: 71.45,
      measurement_5_timestamp: DateTime.utc_now(),
      measurement_6_temp: 71.45,
      measurement_6_timestamp: DateTime.utc_now()
    }
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
