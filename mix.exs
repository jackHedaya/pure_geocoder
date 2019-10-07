defmodule PureGeocoder.MixProject do
  use Mix.Project

  def project do
    [
      app: :pure_geocoder,
      version: "0.1.1",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp description do
    """
    A library for geocoding addresses and reverse geocoding coordinates. Uses OpenStreetMap.
    """
  end

  defp package do
    [
      files: ["lib", "mix.exs", "mix.lock", "README*"],
      maintainers: ["Jack Hedaya"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/jackHedaya/pure_geocoder"}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 1.6.1"},
      {:poison, "~> 4.0"},
      {:ex_doc, "~> 0.19", only: :dev, runtime: false}
    ]
  end
end
