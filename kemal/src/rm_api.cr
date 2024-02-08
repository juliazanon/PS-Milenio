require "kemal"
require "../config/initializers/database"
require "./controllers"
require "json"

module RmApi
  VERSION = "0.1.0"

  # Get all travel plans
  get "/travel_plans" do |env|
    Controllers.get_all_plans(env)
  end

  # Get a specific travel plan
  get "/travel_plans/:id" do |env|
    Controllers.get_plan(env)
  end

  # Create travel plan with array travel_stops as param
  post "/travel_plans" do |env|
    plan = Controllers.create_plan(env)
    response = env.response
    response.status_code = 201

    response.print(plan)
  end

  # Edit travel plan array travel_stops as param
  put "/travel_plans/:id" do |env|
    Controllers.update_plan(env)
  end

  # Delete travel plan
  delete "/travel_plans/:id" do |env|
    result = Controllers.delete_plan(env)
    response = env.response
    response.status_code = 204
  end

  Kemal.run
end
