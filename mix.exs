defmodule NervesHubLinkGeo.MixProject do
  use Mix.Project

  def project do
    [
      app: :nerves_hub_link_geo,
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :inets, :sasl],
      mod: {NervesHubLinkGeo.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:whenwhere, "~> 0.1.1"},
      {:dialyxir, "~> 1.1", only: [:dev, :test], runtime: false},
      {:nerves_hub_link, github: "lawik/nerves_hub_link", branch: "extension-pubsub"}
    ]
  end
end
