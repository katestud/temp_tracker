defmodule TempTrackerUiWeb.TemperatureController do
  use TempTrackerUiWeb, :controller

  @temp_module Application.get_env(:temp_tracker, :temperature, TempTracker.Temperature)

  def show(conn, _params) do
    render conn, "show.html", temp: @temp_module.read_temp
  end
end
