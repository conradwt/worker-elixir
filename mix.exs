defmodule Worker.MixProject do
  use Mix.Project

  def project do
    [
      app: :worker,
      version: "0.1.0",
      elixir: "~> 1.16.2",
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
      {:req, "~> 0.4.14"},
      {:credo, "~> 1.7.6", only: [:dev, :test], runtime: false}
    ]
  end
end
