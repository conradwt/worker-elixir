defmodule Worker.MixProject do
  use Mix.Project

  def project do
    [
      app: :worker,
      version: "0.1.0",
      elixir: "~> 1.17.0-rc.0",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Worker.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:redix, "~> 1.3.0"},
      {:req, "~> 0.5.0"},
      {:credo, "~> 1.7.7-rc.0", only: [:dev, :test], runtime: false}
    ]
  end
end
