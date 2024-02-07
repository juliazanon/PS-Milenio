require "./models/*"
require "./utils"

def get_all_plans(env) : String
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

def get_plan(env) : String
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

def create_plan(env) : String
  stops_json = env.params.json["travel_stops"]?.as(Array)
  stops_ids = stops_json.map { |item| item.to_s.to_i32? }.compact

  plan = TravelPlan.create(travel_stops: stops_ids)
  plan.to_json
end

def update_plan(env) : String
  id = env.params.url["id"].to_i32
  stops_json = env.params.json["travel_stops"]?.as(Array)
  stops_ids = stops_json.map { |item| item.to_s.to_i32? }.compact

  TravelPlan.where { _id == id }.update { {:travel_stops => stops_ids} }

  plan = TravelPlan.find(id)
  plan.to_json
end

def delete_plan(env)
  id = env.params.url["id"].to_i32
  TravelPlan.delete(id)
end
