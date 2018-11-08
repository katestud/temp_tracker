defmodule TempTrackerUiWeb.NarrativeController do
  use TempTrackerUiWeb, :controller

  def show(conn, _params) do
    temperature_module = Application.get_env(:temp_tracker, :temperature, TempTracker.Temperature)

    data =
      temperature_module.recent_readings(1)
      |> Map.put(:location, "Room 1")

    narrative = Wordsmith.API.Client.get_content(%{data: data})
    render conn, "show.html", narrative: narrative
  end
end
