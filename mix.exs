defmodule Nexromancer.MixProject do
  use Mix.Project

  def project do
    [
      app: :nexromancer,
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Nexromancer.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:hammox, "~> 0.6.1", only: :test},
      {:httpoison, "~> 1.8"},
      {:horde, "~> 0.8.7"}
    ]
  end
end
