# NervesHubLinkGeo - Device Location Extension

A simple way to sync the location of your Nerves devices with your choosen NervesHub platform.

The default location resolver uses `https://whenwhere.nerves-project.org/` for geo locating your device by its IP address.


## Installation

Just add `:nerves_hub_link_geo` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:nerves_hub_link_geo, "~> 0.1.0"}
  ]
end
```

## Advanced configuration

You can setup your own location resolver by implementing the `NervesHubLinkGeo.Resolver` behavior.

For example:

```elixir
defmodule MyApp.SpecialResolver do
  @behaviour NervesHubLinkGeo.Resolver

  @impl true
  def resolve_location() do
    magic = MyApp.GPSMagic.lat_lng()

    payload = %{
      latitude: magic.latitude,
      longitude: magic.longitude,
      source: :gps
    }

    {:ok, payload}
  end
end
```

And then to hook it up, add the following to your `config/config.exs`:

```elixir
config :nerves_hub_link_geo,
  resolver: MyApp.SpecialResolver
```

And magic!
