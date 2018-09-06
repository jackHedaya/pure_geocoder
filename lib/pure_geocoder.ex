defmodule PureGeocoder do
  @moduledoc """
  A module that geocodes addresses and reverse geocodes coordinates.
  """

  @doc """
  Geocodes an address.

  Returns `{:ok, %{longitude, latitude}}` or `{:error, reason}`

  ## Examples

      iex> PureGeocoder.geocode("20 West 34th St, New York, NY 10118")
      :world

  """
  def geocode(string) do
    remove_spaces = string |> String.replace(" ", "+")
    body = HTTPoison.get("https://nominatim.openstreetmap.org/search.php?q=" <> remove_spaces)

    case body do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        get_location_code(body)
      {:ok, %HTTPoison.Response{status_code: _}} ->
        {:error, "Error while reaching OpenStreetMap!"}
      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, "HTTPoison error: \"" <> reason <> "\""}
    end
  end

  defp get_location_code(body) do
    parsed = Floki.parse(body)

    data = Floki.find(parsed, ".details")

    if length(data) > 0 do
      {_, props, _} = List.first(data)

      {_, val} = find_prop_with_key(props, "href")

      Regex.run(~r/^details\.php\?place_id=(\d*)$/, val)
      |> tl()
      |> hd()
    else
      nil
    end
  end

  defp find_prop_with_key(props, key) do
    Enum.find(props, fn x ->
      case x do
        {^key, _} -> true
        _ -> false
      end
    end)
  end
  def reverse_geocode(lat, lng) do

  end
end
