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
          latitude: resp.body["latitude"],
          longitude: resp.body["longitude"]
        }

        {:ok, payload}

      {:error, error} ->
        {:error, %{error_code: "HTTP_ERROR", error_description: inspect(error)}}
    end
  end
end
