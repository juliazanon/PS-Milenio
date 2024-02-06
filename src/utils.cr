require "json"
require "http/client"

# Get popularity of a single location by its residents array
def get_location_popularity(residents) : Int32
  total_episodes = 0
  url = "https://rickandmortyapi.com/api/character/"

  begin # Try treating residents as array
    j = 0
    until j >= residents.size
      # Get last digits of the residents url to make a single query
      if index = residents[j].to_s.rindex("/")
        id = residents[j].to_s[index + 1..]
      else
        id = residents[j].to_s
      end
      url += id + ","
      j += 1
    end
  rescue e # If only 1 resident
    begin
      if index = residents.to_s.rindex("/")
        id = residents.to_s[index + 1..]
      else
        id = residents.to_s
      end
      url += id + ","
    rescue e # If zero residents
      return 0
    end
  end
  # Fetch all residents of location and count episodes per resident
  url = url[0, url.size - 1]
  resp = HTTP::Client.get(url)
  if resp.status_code == 200
    residents2 = JSON.parse(resp.body.to_s.strip)
    begin # Try treating residents2 as array
      j = 0
      until j >= residents2.size
        resident = residents2[j]
        episodes = resident["episode"].size
        total_episodes += episodes
        j += 1
      end
    rescue e # Case where there is only 1 resident (not an array)
      begin
        episodes = residents2["episode"].size
        total_episodes += episodes
      rescue e
        return 0
      end
    end
  else
    # Handle errors, if necessary
    raise "Error fetching locations. Status code: #{resp.status_code}"
  end
  return total_episodes
end

# Get array of popularities for travel stops in a plan
def sort_stops(plan) : Array(Int32)
  location_popularities = {} of String => Int32
  dimension_map = Hash(String, Array(String)).new { |hash, key| hash[key] = [] of String } #locations grouped by dimensions
  dimension_popularity = Hash(String, Float64).new(0.0)
  sorted_locations = [] of String
  response = plan.travel_stops.to_a

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

    # Map on locations is not possible due to its type (JSON::Any)
    begin # Try treating locations as Array
      i = 0
      until i >= locations.size
        location = locations[i]
        location_popularities[location["id"].to_s] = get_location_popularity(location["residents"])

        dimension_map[location["dimension"].to_s] << location["id"].to_s

        i += 1
      end
    rescue e # If there is only 1 location
      begin
        location_popularities[locations["id"].to_s] = get_location_popularity(locations["residents"])

        dimension_map[locations["dimension"].to_s] << locations["id"].to_s
      rescue e # If there are zero locations
        # Do nothing
      end
    end

    # Calculate populariry of dimensions by mean of locations populatiries
    dimension_map.each do |dimension, location_ids|
        dimension_popularity[dimension] = location_ids.sum { |id| location_popularities[id] }.to_f / location_ids.size
    end

    # Sort dimensions by popularity
    sorted_dimensions = dimension_popularity.to_a.sort_by { |tuple| tuple[1] }

    # Sort locations within dimensions
    sorted_dimensions.each do |dimension, _|
        locations_within_dimension = dimension_map[dimension]
        sorted_locations.concat(locations_within_dimension.to_a.sort_by { |id| location_popularities[id.to_s] })
    end
    
    response = sorted_locations.map { |str| str.to_i32 } # parse array of strings to int
  else
    # Handle errors, if necessary
    raise "Error fetching locations. Status code: #{res.status_code}"
  end

  return response
end

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

  return sorted_locations
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
    begin # If locations can be treated as Array
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

  return JSON.parse(new_plan.to_json)
end
