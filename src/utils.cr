require "json"
require "http/client"

# Get priority of a single location by its residents array
def get_priority(residents) : Int32
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

# Get array of priorities for travel stops in a plan
def get_priorities(plan) : Hash(String, Int32)
  priorities = {} of String => Int32

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
        priorities[location["id"].to_s] = get_priority(location["residents"])
        i += 1
      end
    rescue e # If there is only 1 location
      begin
        priorities[locations["id"].to_s] = get_priority(locations["residents"])
      rescue e # If there are zero locations
        return priorities
      end
    end
  else
    # Handle errors, if necessary
    raise "Error fetching locations. Status code: #{res.status_code}"
  end

  return priorities
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
      i = 0
      until i >= locations.size
        location = locations[i]
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
