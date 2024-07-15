defmodule NervesHubLinkGeoTest do
  use ExUnit.Case
  use Mimic

  alias NervesHubLink.PubSub
  alias NervesHubLink.Socket

  defmodule TestResolver do
    @behaviour NervesHubLinkGeo.Resolver
    def resolve_location() do
      {:ok, %{source: :geoip, latitude: -41.29710, longitude: 174.79320}}
    end
  end

  defmodule TestResolverWithErrors do
    @behaviour NervesHubLinkGeo.Resolver
    def resolve_location() do
      {:error, "HTTP_ERROR", "stuff went wrong"}
    end
  end

  defmodule TestResolverWithABadReturn do
    @behaviour NervesHubLinkGeo.Resolver
    def resolve_location() do
      "boom"
    end
  end

  describe "resolving" do
    test "default location resolution returns a map" do
      assert %{} = NervesHubLinkGeo.resolve_location()
    end

    test "test resolver returns well formed information" do
      Application.put_env(:nerves_hub_link_geo, :resolver, TestResolver)
      assert %{source: :geoip, latitude: _, longitude: _} = NervesHubLinkGeo.resolve_location()
    end

    test "test error resolver returns well formed information" do
      Application.put_env(:nerves_hub_link_geo, :resolver, TestResolverWithErrors)

      assert %{error_code: "HTTP_ERROR", error_description: "stuff went wrong"} =
               NervesHubLinkGeo.resolve_location()
    end

    test "test bad return error resolver returns well formed information" do
      Application.put_env(:nerves_hub_link_geo, :resolver, TestResolverWithABadReturn)

      assert %{
               error_code: "UNEXPECTED_ERROR",
               error_description:
                 "An unexpected error occurred resolving the devices location : %CaseClauseError{term: \"boom\"}"
             } = NervesHubLinkGeo.resolve_location()
    end
  end

  describe "nerves_hub_link_geo pubsub integration" do
    test "server requests geo location" do
      Application.put_env(:nerves_hub_link_geo, :resolver, TestResolver)

      Socket
      |> expect(:send_message, fn "device", "location:update", %{} -> dbg() end)

      PubSub.subscribe("device")

      # Emulate nerves_hub_link passing us a server event
      PubSub.publish_channel_event("device", "location:request", %{})

      assert_receive %PubSub.Message{
        type: :msg,
        topic: "device",
        event: "location:request",
        params: %{}
      }
    end

    # test "geo location sent after the device has joined" do
    #   # Need to figure this out
    # end
  end
end
