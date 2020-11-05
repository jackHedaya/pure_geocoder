defmodule PureGeocoderTest do
  use ExUnit.Case

  test "geocodes the Empire State Building properly" do
    assert PureGeocoder.geocode("Empire State Building") ==
             {:ok, %{lat: 40.748428399999995, lng: -73.98565461987332}}
  end

  test "reverse geocodes the Empire State Building properly" do
    assert PureGeocoder.reverse_geocode(%{lat: 40.748428399999995, lng: -73.98565461987332}) ==
             {:ok, "350 5th Avenue, New York, New York, 10018, United States of America"}
  end
end
