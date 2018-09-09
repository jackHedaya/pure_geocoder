defmodule PureGeocoder do
  @moduledoc """
  A module that geocodes addresses and reverse geocodes coordinates.
  """

  @doc """
  Geocodes an address.

  Returns `{:ok, %{lat: longitude, lng: latitude}}` or `{:error, reason}`

  ## Examples

      iex> PureGeocoder.geocode("350 5th Ave, New York, NY 10118")
      {:ok, %{lat: 40.7483271, lng: -73.9856549}}

  """
  def geocode(string) do
    remove_spaces = string |> String.replace(" ", "+")

    body =
      HTTPoison.get(
        "https://nominatim.openstreetmap.org/search?q=#{remove_spaces}&format=json"
      )

    with {:ok, %HTTPoison.Response{status_code: 200, body: body}} <- body,
         {:ok, data} <- Poison.decode(body) do
      if length(data) > 0 do
        real = data |> hd()

        lat =
          Map.get(real, "lat")
          |> String.to_float()

        lng =
          Map.get(real, "lon")
          |> String.to_float()

        {:ok, %{lat: lat, lng: lng}}
      else
        {:error, "Location not found!"}
      end
    else
      {:ok, %HTTPoison.Response{status_code: _}} ->
        {:error, "Error while reaching OpenStreetMap!"}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, "HTTPoison error: \"" <> reason <> "\""}
    end
  end

  @doc """
  Reverse geocodes a pair of coordinates.

  Returns `{:ok, address}` or `{:error, reason}`

  ## Examples

      iex> PureGeocoder.geocode(%{lat: 40.7483271, lng: -73.9856549})
      {:ok, "350 5th Avenue, NYC, New York, 10018, USA"}

      iex> PureGeocoder.geocode({40.7483271, -73.9856549})
      {:ok, "350 5th Avenue, NYC, New York, 10018, USA"}

      iex> PureGeocoder.geocode(40.7483271, -73.9856549)
      {:ok, "350 5th Avenue, NYC, New York, 10018, USA"}
  """
  def reverse_geocode(%{:lat => lat, :lng => lng}) do
    reverse_geocode(lat, lng)
  end

  def reverse_geocode({lat, lng}) do
    reverse_geocode(lat, lng)
  end

  def reverse_geocode(lat, lng) do
    lat_string = to_string(lat)
    lng_string = to_string(lng)

    body =
      HTTPoison.get(
        "https://nominatim.openstreetmap.org/reverse?format=json&lat=#{lat_string}&lon=#{lng_string}"
      )

    with {:ok, %HTTPoison.Response{status_code: 200, body: body}} <- body,
         {:ok, data} <- Poison.decode(body) do
      %{
        "address" => %{
          "house_number" => house_num,
          "road" => road,
          "city" => city,
          "state" => state,
          "postcode" => zipcode,
          "country" => country
        }
      } = data

      display =
        house_num <>
          " " <> road <> ", " <> city <> ", " <> state <> ", " <> zipcode <> ", " <> country

      {:ok, display}
    else
      {:ok, %HTTPoison.Response{status_code: code}} ->
        {:error, "Error while reaching OpenStreetMap! Status Code: #{code}"}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, "HTTPoison error: \"" <> reason <> "\""}
    end
  end
end
