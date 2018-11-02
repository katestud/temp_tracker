defmodule TempTrackerUiWeb.TemperatureController do
  use TempTrackerUiWeb, :controller

  def show(conn, _params) do
    temperature_module = Application.get_env(:temp_tracker, :temperature, TempTracker.Temperature)

    temp = temperature_module.read_temp
    render conn, "show.html", temp: temp
  end
end
