defmodule PureGeocoderTest do
  use ExUnit.Case

  test "geocodes the Empire State Building properly" do
    assert PureGeocoder.geocode("350 5th Ave, New York, NY 10118") ==
             {:ok, %{lat: 40.7483271, lng: -73.9856549}}
  end

  test "reverse geocodes the Empire State Building properly" do
    assert PureGeocoder.reverse_geocode(%{lat: 40.7483271, lng: -73.9856549}) ==
      {:ok, "350 5th Avenue, NYC, New York, 10018, USA"}
  end
end
