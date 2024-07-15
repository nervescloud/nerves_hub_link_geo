defmodule NervesHubGeo.DefaultResolver do
  @behaviour NervesHubGeo.Resolver

  alias NervesHubGeo.Resolver

  require Logger

  @impl Resolver
  def resolve_location() do
    case Whenwhere.asks() do
      {:ok, resp} ->
        payload = %{
          source: :geoip,
          latitude: resp[:latitude],
          longitude: resp[:longitude]
        }

        {:ok, payload}

      {:error, error} ->
        {:error, "HTTP_ERROR", inspect(error)}
    end
  end
end
