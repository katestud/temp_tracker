defmodule TempTracker.Temperature do
  use GenServer
  require Logger

  @sensor_dir "/sys/bus/w1/devices/"
  @measure_after :timer.seconds(60)

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

  # GenServer API

  def init(_opts) do
    state = %{
      sensors: get_sensors(),
      temperatures: %{}
    }
    schedule_temp_reading()

    {:ok, state}
  end

  def handle_info(:read_temp, state) do
    temps =
      state[:sensors]
      |> Enum.with_index
      |> Enum.map(&read_temp(&1))
      |> IO.inspect

    # state = %{state | temperatures: temps}
    Logger.info "State is: #{inspect state}"
    schedule_temp_reading()

    {:noreply, put_in(state, [:temperatures, time_string()], temps)}
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

  defp time_string do
    DateTime.utc_now
    |> DateTime.truncate(:second)
    |> DateTime.to_string
  end

  defp schedule_temp_reading do
    Process.send_after(self(), :read_temp, @measure_after)
  end

end
