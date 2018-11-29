defmodule TempTracker.Temperature do
  use GenServer
  require Logger

  @sensor_dir "/sys/bus/w1/devices/"
  @measure_after :timer.minutes(3)

  # Public API

  @doc """
  Starts temperature tracking
  """
  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def read_temp do
    get_sensors()
    |> List.first
    |> read_temp
  end

  def recent_readings, do: GenServer.call(__MODULE__, :recent_readings)

  # GenServer API

  def init(_opts) do
    state = %{
      sensors: get_sensors(),
      sensor_0: []
    }
    schedule_temp_reading()

    {:ok, state}
  end

  def handle_info(:update_temp_state, state) do
    Logger.info "State is: #{inspect state}"
    temp =
      state[:sensors]
      |> List.first
      |> read_temp

    %{sensor_0: previous_temps} = state
    temps = [{current_time(), temp} | previous_temps]

    schedule_temp_reading()

    {:noreply, put_in(state, [:sensor_0], temps)}
  end

  def handle_call(:recent_readings, _from, state) do
    %{sensor_0: temps} = state

    {:reply, recent_readings(temps), state}
  end

  defp get_sensors do
    File.ls!(@sensor_dir)
    |> Enum.filter(&(String.starts_with?(&1, "28-")))
  end

  defp read_temp({sensor, index}) do
    atom =
      "sensor_" <> Integer.to_string(index)
      |> String.to_atom

    %{atom => read_temp(sensor)}
  end

  defp read_temp(sensor) do
    File.read!("#{@sensor_dir}#{sensor}/w1_slave")
    |> extract_temp
  end

  defp extract_temp(sensor_data) do
    {temp, _} =
      Regex.run(~r/t=(\d+)/, sensor_data)
      |> List.last
      |> Float.parse

    temp / 1000 * 1.8 + 32
    |> Float.round(2)
  end

  defp current_time do
    DateTime.utc_now
    |> DateTime.truncate(:second)
    |> DateTime.to_string
    |> String.slice(0..18)
  end

  defp schedule_temp_reading do
    Process.send_after(self(), :update_temp_state, @measure_after)
  end

  defp recent_readings([]) do
    recent_readings([{nil, nil}])
  end
  defp recent_readings([{timestamp, temp} | tail]) do
      initial_state = %{
          "measurement_1_temp" => temp,
          "measurement_1_timestamp" => timestamp
      }
      recent_readings(initial_state, tail, 2)
  end

  defp recent_readings(map, _, 11), do: map
  defp recent_readings(map, [{timestamp, temp} | tail], num) do
      map
      |> Map.put("measurement_#{num}_temp", temp)
      |> Map.put("measurement_#{num}_timestamp", timestamp)
      |> recent_readings(tail, num + 1)
  end
  defp recent_readings(map, [], num) do
      map
      |> Map.put("measurement_#{num}_temp", nil)
      |> Map.put("measurement_#{num}_timestamp", nil)
      |> recent_readings([], num + 1)
  end

end
