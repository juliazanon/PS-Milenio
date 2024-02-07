require "./spec_helper"
require "../src/models/travel_plan"

# get_id_from_url
it "returns id from the end of an url" do
  id = get_id_from_url("https://rickandmortyapi.com/api/character/106")
  id.should eq("106,")

  # url doesn't have id
  id = get_id_from_url("")
  id.should eq(",")
end

# get_query_url
it "returns query url with all residents ids" do 
  residents = get_residents("many")
  url = get_query_url(residents)
  url.should eq("https://rickandmortyapi.com/api/character/41,193,238,333")

  residents = get_residents("one")
  url = get_query_url(residents)
  url.should eq("https://rickandmortyapi.com/api/character/6")

  residents = get_residents("zero")
  url = get_query_url(residents)
  url.should eq("https://rickandmortyapi.com/api/character")
end

# get_total_episodes
it "returns total episodes present in all characters of a location" do
  total = get_total_episodes("https://rickandmortyapi.com/api/character/106,393,58,450,451")
  total.should eq(8)

  total = get_total_episodes("https://rickandmortyapi.com/api/character/58")
  total.should eq(4)

  total = get_total_episodes("https://rickandmortyapi.com/api/character")
  total.should eq(0)
end

# get_location_popularity
it "returns location's popularity value" do
  residents = get_residents("many")
  pop = get_location_popularity(residents)
  pop.should eq(6)

  residents = get_residents("one")
  pop = get_location_popularity(residents)
  pop.should eq(1)

  residents = get_residents("zero")
  pop = get_location_popularity(residents)
  pop.should eq(0)
end

# sort_stops_by_name
it "returns an array of travel_stops sorted by name" do
  locations = get_locations("many")
  travel_stops = [2,7,9,11,19]
  sorted = sort_stops_by_name(locations, travel_stops)
  sorted.should eq([2,11,19,7,9])
end

# sort_stops
it "returns sorted array of travel_stops by dimension and location popularity, then location name" do
  plan = TravelPlan.new({travel_stops: [2,7,9,11,19]})
  sorted = sort_stops(plan)
  sorted.should eq([19,9,2,11,7])
end

# sort_locations_by_id
it "returns locations array sorted according to the order of travel_stops passed" do 
  locations = get_locations("many")
  travel_stops = [19,9,2,11,7]
  sorted = sort_locations_by_id(locations, travel_stops)
  sorted.should eq(get_sorted_locations())
end

# expand_plan
it "returns expanded travel plan" do
  plan = TravelPlan.new({travel_stops: [2,7,9,11,19]})
  expanded = expand_plan(plan)
  expanded.should eq(get_expanded_plan())
end