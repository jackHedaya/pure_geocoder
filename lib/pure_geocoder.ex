defmodule PureGeocoder do
  @moduledoc """
  A module that geocodes addresses and reverse geocodes coordinates.
  """

  @doc """
  Geocodes an address.

  Returns `{:ok, %{lat: longitude, lng: latitude}}` or `{:error, reason}`

  ## Examples

      iex> PureGeocoder.geocode("20 West 34th St, New York, NY 10118")
      {:ok, %{lat: 40.7496458, lng: -73.9874169}}

  """
  def geocode(string) do
    remove_spaces = string |> String.replace(" ", "+")

    body =
      HTTPoison.get(
        "https://nominatim.openstreetmap.org/search.php?q=" <> remove_spaces <> "&format=json"
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

      iex> PureGeocoder.geocode(%{lat: 40.7496458, lng: -73.9874169})
      "20 West 34th St, New York, NY 10118"

      iex> PureGeocoder.geocode({40.7496458, -73.9874169})
      "20 West 34th St, New York, NY 10118"

      iex> PureGeocoder.geocode(40.7496458, -73.9874169)
      "20 West 34th St, New York, NY 10118"
  """
  def reverse_geocode(%{:latitude => lat, :longitude => lng}) do
    reverse_geocode(lat, lng)
  end

  def reverse_geocode({lat, lng}) do
    reverse_geocode(lat, lng)
  end

  def reverse_geocode(lat, lng) do
    res = HTTPoison.get("https://nominatim.openstreetmap.org/search/?q=" <> lat <> ",%20" <> lng)

    case res do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        html = Floki.parse(body)

        Floki.find(html, ".name")
        |> IO.inspect()

      {:ok, %HTTPoison.Response{status_code: _}} ->
        {:error, "Error while reaching OpenStreetMap!"}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, "HTTPoison error: \"" <> reason <> "\""}
    end
  end
end
