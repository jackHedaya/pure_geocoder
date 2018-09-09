defmodule PureGeocoderTest do
  use ExUnit.Case

  test "gets the proper coordinates for the Empire State Building" do
    assert PureGeocoder.geocode("20 West 34th St, New York, NY 10118") ==
             {:ok, %{lat: 40.7486538125, lng: -73.9853043125}}
  end
end
