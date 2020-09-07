defmodule TempTrackerUiWeb.TempLive do
  # If you generated an app with mix phx.new --live,
  # the line below would be: use MyAppWeb, :live_view
  use TempTrackerUiWeb, :live_view

  @temp_module Application.get_env(:temp_tracker, :temperature, TempTracker.Temperature)

  def render(assigns) do
    ~L"""
    <div class="jumbotron">
      <h2><%= @temperature %>°</h2>
    </div>
    """
  end

  def mount(_params, _thing, socket) do
    if connected?(socket), do: Process.send_after(self(), :update, 10000)

    temperature = @temp_module.read_temp
    {:ok, assign(socket, temperature: temperature)}
  end

  def handle_info(:update, socket) do
    Process.send_after(self(), :update, 10000)
    temperature = @temp_module.read_temp
    {:noreply, assign(socket, :temperature, temperature)}
  end
end
