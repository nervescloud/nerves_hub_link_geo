defmodule NervesHubGeo.MixProject do
  use Mix.Project

  def project do
    [
      app: :nerves_hub_geo,
      version: "0.1.0",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :inets, :sasl],
      mod: {NervesHubGeo.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:nerves_hub_link, path: "../nerves_hub_link"}
    ]
  end
end
