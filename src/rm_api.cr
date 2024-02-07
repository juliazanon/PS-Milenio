require "kemal"
require "../config/initializers/database"
require "./controllers"
require "json"

module RmApi
  VERSION = "0.1.0"

  # Get all travel plans
  get "/travel_plans" do |env|
    get_all_plans(env)
  end

  # Get a specific travel plan
  get "/travel_plans/:id" do |env|
    get_plan(env)
  end

  # Create travel plan with array travel_stops as param
  post "/travel_plans" do |env|
    create_plan(env)
  end

  # Edit travel plan array travel_stops as param
  put "/travel_plans/:id" do |env|
    update_plan(env)
  end

  # Delete travel plan
  delete "/travel_plans/:id" do |env|
    delete_plan(env)
  end

  Kemal.run
end
