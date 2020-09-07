defmodule TempTracker.FakeTemp do
  use GenServer

  # Public API

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def read_temp do
    Enum.random(65..88)
  end

  def recent_readings do
    %{
      measurement_1_temp: 71.20,
      measurement_1_timestamp: current_time(),
      measurement_2_temp: 71.45,
      measurement_2_timestamp: current_time(),
      measurement_3_temp: 71.45,
      measurement_3_timestamp: current_time(),
      measurement_4_temp: 71.45,
      measurement_4_timestamp: current_time(),
      measurement_5_temp: 71.45,
      measurement_5_timestamp: current_time(),
      measurement_6_temp: 71.45,
      measurement_6_timestamp: current_time(),
      measurement_7_temp: 71.45,
      measurement_7_timestamp: current_time(),
      measurement_8_temp: 71.45,
      measurement_8_timestamp: current_time(),
      measurement_9_temp: 71.45,
      measurement_9_timestamp: current_time(),
      measurement_10_temp: 71.23,
      measurement_10_timestamp: current_time()
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

  defp current_time do
    DateTime.utc_now
    |> DateTime.truncate(:second)
    |> DateTime.to_string
    |> String.slice(0..18)
  end

end
