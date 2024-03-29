require "json"
require "http/client"

##########################
# Functions for optimize #
##########################

def get_id_from_url(url) : String
  if index = url.to_s.rindex("/")
    id = url.to_s[index + 1..]
  else
    id = url.to_s
  end
  id + ","
end

def get_query_url(residents)
  url = "https://rickandmortyapi.com/api/character/"

  # Get array of residents url and store the ids in an array
  begin # Try treating residents as array
    j = 0
    until j >= residents.size
      # Get last digits of the residents url to make a single query
      url += get_id_from_url(residents[j])
      j += 1
    end
  rescue # If only 1 resident
    begin
      url += get_id_from_url(residents)
    rescue # If zero residents
      puts "No residents"
    end
  end
  url = url[0, url.size - 1] # remove the last character (, or /)
end

def get_total_episodes(url)
  total_episodes = 0
  # Fetch all resident objects of location and count episodes per resident
  response = HTTP::Client.get(url)
  if response.status_code == 200
    residents = JSON.parse(response.body.to_s.strip)

    begin # Try treating residents as array
      j = 0
      until j >= residents.size
        episodes = residents[j]["episode"].size
        total_episodes += episodes
        j += 1
      end
    rescue e # Case where there is only 1 resident (not an array)
      begin
        episodes = residents["episode"].size
        total_episodes += episodes
      rescue e # If there are zero residents
        return 0
      end
    end
  else
    # Handle errors, if necessary
    raise "Error fetching locations. Status code: #{response.status_code}"
  end

  total_episodes
end

# Get popularity of a single location by its residents array
def get_location_popularity(residents) : Int32
  url = get_query_url(residents)
  get_total_episodes(url)
end

# Returns the array travel_stops sorted by name
def sort_stops_by_name(locations, travel_stops) : Array(Int32)
  # Sort locations alphabetically
  locations_array = [] of JSON::Any
  i = 0
  until i >= locations.size
    locations_array << locations[i]
    i += 1
  end

  sorted_locations = locations_array.sort_by { |loc| loc["name"].to_s }

  # Hash to store location names by ID
  location_names = Hash(String, String).new
  sorted_locations.each do |loc|
    location_names[loc["id"].to_s] = loc["name"].to_s
  end

  travel_stops.sort_by! { |id| location_names[id.to_s] }

  travel_stops
end

# Sort travel_stops array according to dimension and location popularities, then location name
def sort_stops(plan) : Array(Int32)
  location_popularity_map = {} of String => Int32                                          # hash os location popularities by id
  name_indexes_map = {} of String => Int32                                                 # hash of the indexes on the array sorted by name
  dimension_map = Hash(String, Array(String)).new { |hash, key| hash[key] = [] of String } # locations grouped by dimensions
  dimension_popularity = Hash(String, Float64).new(0.0)                                    # hash of dimension popularities by name
  sorted_locations = [] of String                                                          # array of sorted travel_stops
  response = plan.travel_stops.to_a                                                        # default response

  # Fetch locations
  url = "https://rickandmortyapi.com/api/location/"
  plan.travel_stops.each do |stop|
    url += "#{stop},"
  end
  url = url[0, url.size - 1] # remove the last character (,)

  res = HTTP::Client.get(url)
  if res.status_code == 200
    locations = JSON.parse(res.body)

    name_array = sort_stops_by_name(locations, plan.travel_stops) # travel_stops sorted by name

    # Populate maps
    begin # Try treating locations as Array
      i = 0
      until i >= locations.size
        location = locations[i]
        id = location["id"]

        if (id)
          location_popularity_map[id.to_s] = get_location_popularity(location["residents"])

          dimension_map[location["dimension"].to_s] << id.to_s

          index = name_array.index(id)
          name_indexes_map[id.to_s] = index if index
        end

        i += 1
      end
    rescue e # If there is only 1 location
      begin
        id = locations["id"]

        if (id)
          location_popularity_map[id.to_s] = get_location_popularity(locations["residents"])

          dimension_map[locations["dimension"].to_s] << id.to_s

          index = name_array.index(id)
          name_indexes_map[id.to_s] = index if index
        end
      rescue e # If there are zero locations
        puts "No location"
      end
    end

    # Calculate populariry of dimensions by mean of locations populatiries
    dimension_map.each do |dimension, location_ids|
      dimension_popularity[dimension] = location_ids.sum { |id| location_popularity_map[id] }.to_f / location_ids.size
    end

    # Sort dimensions by popularity
    sorted_dimensions = dimension_popularity.to_a.sort_by { |dimension| dimension[1] }

    # Sort locations within dimensions by location popularity then name
    sorted_dimensions.each do |dimension, _|
      locations_within_dimension = dimension_map[dimension]
      sorted_locations.concat(locations_within_dimension.to_a.sort_by do |id|
        [location_popularity_map[id.to_s], name_indexes_map[id.to_s]]
      end)
    end

    response = sorted_locations.map { |str| str.to_i32 } # parse array of strings to int
  else
    # Handle errors, if necessary
    raise "Error fetching locations. Status code: #{res.status_code}"
  end

  return response
end

########################
# Functions for expand #
########################

# Sort locations fetched by the ids passed in travel_stops
def sort_locations_by_id(locations, travel_stops) : Array(JSON::Any)
  sorted_locations = Array(JSON::Any).new
  travel_stops.each do |id|
    i = 0
    until i >= locations.size
      location = locations[i]
      if location["id"].to_s.to_i32 == id
        sorted_locations << location
      end
      i += 1
    end
  end

  sorted_locations
end

# Get expanded travel plan
def expand_plan(plan) : JSON::Any
  new_plan = JSON::Any.new({} of String => JSON::Any)
  # Fetch locations
  url = "https://rickandmortyapi.com/api/location/"
  plan.travel_stops.each do |stop|
    url += "#{stop},"
  end
  # Remove the last character (,)
  url = url[0, url.size - 1]
  res = HTTP::Client.get(url)
  if res.status_code == 200
    locations = JSON.parse(res.body)

    # Write new JSON model
    expanded = [] of JSON::Any
    begin                                                                   # If locations can be treated as Array
      sorted_locations = sort_locations_by_id(locations, plan.travel_stops) # The fetch gets the locations ordered by id
      i = 0
      until i >= sorted_locations.size
        location = sorted_locations[i]
        obj = {
          "id":        location["id"],
          "name":      location["name"],
          "type":      location["type"],
          "dimension": location["dimension"],
        }
        expanded << JSON.parse(obj.to_json)
        i += 1
      end
    rescue e # If only 1 location
      begin
        obj = {
          "id":        locations["id"],
          "name":      locations["name"],
          "type":      locations["type"],
          "dimension": locations["dimension"],
        }
        expanded << JSON.parse(obj.to_json)
      rescue e
        puts "No locations"
      end
    end

    new_plan = {
      "id":           plan.id,
      "travel_stops": expanded,
    }
  else
    # Handle errors, if necessary
    raise "Error fetching locations. Status code: #{res.status_code}"
  end

  JSON.parse(new_plan.to_json)
end
