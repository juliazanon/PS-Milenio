require "spec"
require "json"
require "http/client"
require "../src/utils"

def get_residents(n) : Array(String) | Tuple(String) | JSON::Any
  if (n == "many")
    residents = [
      "https://rickandmortyapi.com/api/character/41",
      "https://rickandmortyapi.com/api/character/193",
      "https://rickandmortyapi.com/api/character/238",
      "https://rickandmortyapi.com/api/character/333",
    ]

    return residents
  elsif (n == "one") # With only one resident crystal interprets as JSON::Any instead of array
    residents = {
      "https://rickandmortyapi.com/api/character/6",
    }

    return residents
  else # Empty residents
    return JSON::Any.new({} of String => JSON::Any)
  end
end

def get_locations(n) : JSON::Any
  if (n == "many")
    locations = [
      {
        "id"        => 2,
        "name"      => "Abadango",
        "type"      => "Cluster",
        "dimension" => "unknown",
        "residents" => [
          "https://rickandmortyapi.com/api/character/6",
        ],
        "url"     => "https://rickandmortyapi.com/api/location/2",
        "created" => "2017-11-10T13:06:38.182Z",
      },
      {
        "id"        => 7,
        "name"      => "Immortality Field Resort",
        "type"      => "Resort",
        "dimension" => "unknown",
        "residents" => [
          "https://rickandmortyapi.com/api/character/23",
          "https://rickandmortyapi.com/api/character/204",
          "https://rickandmortyapi.com/api/character/320",
        ],
        "url"     => "https://rickandmortyapi.com/api/location/7",
        "created" => "2017-11-10T13:09:17.136Z",
      },
      {
        "id"        => 9,
        "name"      => "Purge Planet",
        "type"      => "Planet",
        "dimension" => "Replacement Dimension",
        "residents" => [
          "https://rickandmortyapi.com/api/character/26",
          "https://rickandmortyapi.com/api/character/139",
          "https://rickandmortyapi.com/api/character/202",
          "https://rickandmortyapi.com/api/character/273",
        ],
        "url"     => "https://rickandmortyapi.com/api/location/9",
        "created" => "2017-11-10T13:09:29.566Z",
      },
      {
        "id"        => 11,
        "name"      => "Bepis 9",
        "type"      => "Planet",
        "dimension" => "unknown",
        "residents" => [
          "https://rickandmortyapi.com/api/character/35",
        ],
        "url"     => "https://rickandmortyapi.com/api/location/11",
        "created" => "2017-11-18T11:26:03.325Z",
      },
      {
        "id"        => 19,
        "name"      => "Gromflom Prime",
        "type"      => "Planet",
        "dimension" => "Replacement Dimension",
        "residents" => [] of String,
        "url"       => "https://rickandmortyapi.com/api/location/19",
        "created"   => "2017-11-18T11:39:52.165Z",
      },
    ]

    json_string = locations.to_json

    # Parse the JSON string back to a Crystal object
    parsed_json = JSON.parse(json_string)

    return parsed_json
  elsif (n == "one")
    locations = [
      {
        "id"        => 2,
        "name"      => "Abadango",
        "type"      => "Cluster",
        "dimension" => "unknown",
        "residents" => [
          "https://rickandmortyapi.com/api/character/6",
        ],
        "url"     => "https://rickandmortyapi.com/api/location/2",
        "created" => "2017-11-10T13:06:38.182Z",
      },
    ]

    json_string = locations.to_json

    # Parse the JSON string back to a Crystal object
    parsed_json = JSON.parse(json_string)

    return parsed_json
  else
    return JSON::Any.new({} of String => JSON::Any)
  end
end

def get_sorted_locations : Array
  locations = [
    {
      "id"        => 19,
      "name"      => "Gromflom Prime",
      "type"      => "Planet",
      "dimension" => "Replacement Dimension",
      "residents" => [] of String,
      "url"       => "https://rickandmortyapi.com/api/location/19",
      "created"   => "2017-11-18T11:39:52.165Z",
    },
    {
      "id"        => 9,
      "name"      => "Purge Planet",
      "type"      => "Planet",
      "dimension" => "Replacement Dimension",
      "residents" => [
        "https://rickandmortyapi.com/api/character/26",
        "https://rickandmortyapi.com/api/character/139",
        "https://rickandmortyapi.com/api/character/202",
        "https://rickandmortyapi.com/api/character/273",
      ],
      "url"     => "https://rickandmortyapi.com/api/location/9",
      "created" => "2017-11-10T13:09:29.566Z",
    },
    {
      "id"        => 2,
      "name"      => "Abadango",
      "type"      => "Cluster",
      "dimension" => "unknown",
      "residents" => [
        "https://rickandmortyapi.com/api/character/6",
      ],
      "url"     => "https://rickandmortyapi.com/api/location/2",
      "created" => "2017-11-10T13:06:38.182Z",
    },
    {
      "id"        => 11,
      "name"      => "Bepis 9",
      "type"      => "Planet",
      "dimension" => "unknown",
      "residents" => [
        "https://rickandmortyapi.com/api/character/35",
      ],
      "url"     => "https://rickandmortyapi.com/api/location/11",
      "created" => "2017-11-18T11:26:03.325Z",
    },
    {
      "id"        => 7,
      "name"      => "Immortality Field Resort",
      "type"      => "Resort",
      "dimension" => "unknown",
      "residents" => [
        "https://rickandmortyapi.com/api/character/23",
        "https://rickandmortyapi.com/api/character/204",
        "https://rickandmortyapi.com/api/character/320",
      ],
      "url"     => "https://rickandmortyapi.com/api/location/7",
      "created" => "2017-11-10T13:09:17.136Z",
    },
  ]
  return locations
end

def get_expanded_plan : Hash
  plan = {
    "id"           => nil,
    "travel_stops" => [
      {
        "id"        => 2,
        "name"      => "Abadango",
        "type"      => "Cluster",
        "dimension" => "unknown",
      },
      {
        "id"        => 7,
        "name"      => "Immortality Field Resort",
        "type"      => "Resort",
        "dimension" => "unknown",
      },
      {
        "id"        => 9,
        "name"      => "Purge Planet",
        "type"      => "Planet",
        "dimension" => "Replacement Dimension",
      },
      {
        "id"        => 11,
        "name"      => "Bepis 9",
        "type"      => "Planet",
        "dimension" => "unknown",
      },
      {
        "id"        => 19,
        "name"      => "Gromflom Prime",
        "type"      => "Planet",
        "dimension" => "Replacement Dimension",
      },
    ],
  }
  return plan
end
