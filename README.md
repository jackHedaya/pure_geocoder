# PureGeocoder

[![Hex.pm](https://img.shields.io/hexpm/v/pure_geocoder.svg)](https://hex.pm/packages/pure_geocoder)
[![Hex.pm](https://img.shields.io/hexpm/dt/pure_geocoder.svg)](https://hex.pm/packages/pure_geocoder)

A library for geocoding addresses and reverse geocoding coordinates. Uses <a href="https://github.com/openstreetmap/Nominatim">Nominatim</a>.

<a href="https://hexdocs.pm/pure_geocoder/PureGeocoder.html">Documentation</a>

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
