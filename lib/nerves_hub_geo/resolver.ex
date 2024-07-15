defmodule NervesHubGeo.Resolver do
  @typedoc "Supported location sources"
  @type sources() :: :gps | :geoip | :custom

  @typedoc "Required information for a successful location resolution"
  @type required_location_information() :: %{
          latitude: float(),
          longitude: float(),
          source: sources()
        }

  @typedoc "Supported responses from `resolve_location/1`"
  @type location_responses() ::
          {:ok, required_location_information()}
          | {:ok, %{required_location_information() | accuracy: pos_integer()}}
          | {:error, %{error_code: String.t(), error_description: String.t()}}

  @callback resolve_location() :: location_responses()
end
