require "kemal"
require "../config/initializers/database"
require "./models/*"

module RmApi
  VERSION = "0.1.0"

  get "/travel_plans" do
    plans = {id: 1, travel_stops: [1, 2]}
    plans.to_json
  end

  post "/travel_plans" do |env|
    travel_stops_json =  env.params.json["travel_stops"]?.as(Array)
    travel_stops_ids = travel_stops_json.map { |item| item.to_s.to_i32? }.compact

    # travel_stops = TravelStop.where { _id.in(travel_stops_ids) }.to_a

    new_travel_plan = TravelPlan.create(travel_stops: travel_stops_ids)
    puts new_travel_plan.inspect
  end

  post "/travel_stops" do |env|
    name = env.params.json["name"]?.as(String)
    type = env.params.json["type"]?.as(String)
    dimension = env.params.json["dimension"]?.as(String)

    new_stop = TravelStop.create({name: name, type: type, dimension: dimension})
    puts new_stop.inspect
  end

  Kemal.run
end
