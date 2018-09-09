# PureGeocoder

A library for geocoding addresses and reverse geocoding coordinates. Uses <a href="https://github.com/openstreetmap/Nominatim">Nominatim</a>.

Documentation: https://hexdocs.pm/pure_geocoder/api-reference.html

## Contributing
### Getting Started
+ `$ git clone https://github.com/jackHedaya/pure_geocoder`
+ `$ cd pure_geocoder`
+ `$ mix deps.get`

## Installation
Add dependency to `mix.exs` file:

`defp deps do 
   [{:pure_geocoder, "~> 0.1.0"}] 
end`

### Dependencies
+ <a href="https://github.com/devinus/poison">Poison</a>
+ <a href="https://github.com/edgurgel/httpoison">HTTPoison</a>
