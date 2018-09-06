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
        code = get_location_code(body)

        case code do
          nil -> {:error, "Unable to find a location code."}
          _ -> get_coordinates(code)
        end

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

  defp get_coordinates(code) do
    res = HTTPoison.get("https://nominatim.openstreetmap.org/details.php?place_id=" <> code)

    case res do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        pull_coordinates_from_body(body)

      {:ok, %HTTPoison.Response{status_code: _}} ->
        {:error, "Error while reaching OpenStreetMap!"}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, "HTTPoison error: \"" <> reason <> "\""}
    end
  end

  defp pull_coordinates_from_body(body) do
    parsed = Floki.parse(body)

    {_, _, [loc]} = Enum.at(Floki.find(parsed, "td"), 15)

    split_loc = String.split(loc, ",")

    lat =
      split_loc
      |> hd()
      |> String.to_float()

    lng =
      split_loc
      |> List.last()
      |> String.to_float()

    %{:latitude => lat, :longitude => lng}
  end

  def reverse_geocode(lat, lng) do
  end
end
