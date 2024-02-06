require "kemal"
require "../config/initializers/database"
require "./models/*"
require "./utils"
require "json"

module RmApi
  VERSION = "0.1.0"

  # Get all travel plans
  get "/travel_plans" do |env|
    # Get request params
    optimize_str = env.params.query["optimize"]?
    optimize = optimize_str.to_s == "true" || false
    expand_str = env.params.query["expand"]?
    expand = expand_str.to_s == "true" || false

    plans = TravelPlan.all.to_a
    response = plans.to_json

    # Sort travel stops
    if (optimize)
      plans.each do |plan|
        plan.travel_stops = sort_stops(plan)
      end

      response = plans.to_json
    end

    # Expand travel stops
    if (expand)
      new_plans = [] of JSON::Any
      plans.each do |plan|
        new_plan = expand_plan(plan)
        new_plans << JSON.parse(new_plan.to_json)
      end

      response = new_plans.to_json
    end

    response
  end

  get "/travel_plans/:id" do |env|
    id = env.params.url["id"].to_i32

    # Get request params
    optimize_str = env.params.query["optimize"]?
    optimize = optimize_str.to_s == "true" || false
    expand_str = env.params.query["expand"]?
    expand = expand_str.to_s == "true" || false

    plan = TravelPlan.find(id)
    response = plan.to_json

    if (plan) # Check for Nil
      # Sort travel stops
      if (optimize)
        plan.travel_stops = sort_stops(plan)
        response = plan.to_json
      end

      # Expand travel stops
      if (expand)
        response = expand_plan(plan).to_json
      end
    end

    response
  end

  # Create travel plan with array as input
  post "/travel_plans" do |env|
    travel_stops_json = env.params.json["travel_stops"]?.as(Array)
    travel_stops_ids = travel_stops_json.map { |item| item.to_s.to_i32? }.compact

    new_travel_plan = TravelPlan.create(travel_stops: travel_stops_ids)
    new_travel_plan.to_json
  end

  put "/travel_plans/:id" do |env|
    id = env.params.url["id"].to_i32
    travel_stops_json = env.params.json["travel_stops"]?.as(Array)
    travel_stops_ids = travel_stops_json.map { |item| item.to_s.to_i32? }.compact

    TravelPlan.where { _id == id }.update { {:travel_stops => travel_stops_ids} }

    plan = TravelPlan.find(id)
    plan.to_json
  end

  delete "/travel_plans/:id" do |env|
    id = env.params.url["id"].to_i32
    TravelPlan.delete(id)
  end
  Kemal.run
end
