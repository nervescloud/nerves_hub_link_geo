defmodule NervesHubLinkGeo do
  use GenServer

  alias NervesHubLinkGeo.DefaultResolver
  alias NervesHubLink.PubSub

  require Logger

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @impl GenServer
  def init(_opts) do
    PubSub.subscribe("device")
    {:ok, %{}}
  end

  def resolve_location() do
    case resolver().resolve_location() do
      {:ok, result} ->
        Logger.debug(
          "[#{inspect(__MODULE__)}] Location resolution completed successfully using #{resolver()}"
        )

        result

      {:error, code, description} ->
        Logger.debug(
          "[#{inspect(__MODULE__)}] Error resolving location using #{resolver()} : (#{code}) #{description}"
        )

        %{error_code: code, error_description: description}
    end
  rescue
    error ->
      Logger.debug(
        "[#{inspect(__MODULE__)}] Unexpected error occurred while resolving the devices location using #{resolver()} : #{inspect(error)}"
      )

      %{
        error_code: "UNEXPECTED_ERROR",
        error_description:
          "An unexpected error occurred resolving the devices location : #{inspect(error)}"
      }
  end

  @impl GenServer
  def handle_info({:broadcast, :join, "device", _reply}, state) do
    location = resolve_location()

    PubSub.publish_to_hub("device", "location:update", location)

    {:noreply, state}
  end

  def handle_info({:broadcast, :msg, "device", "location:request", _params}, state) do
    location = resolve_location()

    PubSub.publish_to_hub("device", "location:update", location)

    {:noreply, state}
  end

  def handle_info({:broadcast, _, _, _}, state) do
    {:noreply, state}
  end

  def handle_info({:broadcast, _, _, _, _}, state) do
    {:noreply, state}
  end

  defp resolver() do
    Application.get_env(:nerves_hub_link_geo, :resolver, DefaultResolver)
  end
end
