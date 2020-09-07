defmodule TempTrackerFw.MixProject do
  use Mix.Project

  @app :temp_tracker_fw
  @all_targets [:rpi0, :rpi3]

  def project do
    [
      app: @app,
      version: "0.1.0",
      elixir: "~> 1.9",
      archives: [nerves_bootstrap: "~> 1.8"],
      start_permanent: Mix.env() == :prod,
      build_embedded: Mix.target() != :host,
      aliases: [loadconfig: [&bootstrap/1]],
      deps: deps(),
      releases: [{@app, release()}],
      preferred_cli_target: [run: :host, test: :host],
    ]
  end

  # Starting nerves_bootstrap adds the required aliases to Mix.Project.config()
  # Aliases are only added if MIX_TARGET is set.
  def bootstrap(args) do
    Application.start(:nerves_bootstrap)
    Mix.Task.run("loadconfig", args)
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {TempTrackerFw.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # Dependencies for all targets
      {:nerves, "~> 1.6.0", runtime: false},
      {:shoehorn, "~> 0.6"},
      {:ring_logger, "~> 0.4"},
      {:toolshed, "~> 0.2.13"},

      {:temp_tracker, path: "../temp_tracker", targets: @all_targets, env: Mix.env()},
      {:temp_tracker_ui, path: "../temp_tracker_ui", targets: @all_targets, env: Mix.env()},

      # Dependencies for all targets except :host
      {:nerves_runtime, "~> 0.6", targets: @all_targets},
      {:nerves_pack, "~> 0.2", targets: @all_targets},

      {:nerves_system_rpi0, "~> 1.5", runtime: false, targets: :rpi0},
      {:nerves_system_rpi3, "~> 1.5", runtime: false, targets: :rpi3},
    ]
  end

  def release do
    [
      overwrite: true,
      cookie: "#{@app}_cookie",
      include_erts: &Nerves.Release.erts/0,
      steps: [&Nerves.Release.init/1, :assemble],
      strip_beams: Mix.env() == :prod
    ]
  end
end
