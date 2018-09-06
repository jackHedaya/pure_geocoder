defmodule PureGeocoderTest do
  use ExUnit.Case

  test "gets the proper coordinates for the Empire State Building" do
    assert PureGeocoder.geocode("20 West 34th St, New York, NY 10118") ==
        %{latitude: 40.7496458, longitude: -73.9874169}
  end
end
