require "kemal"
require "../../config/initializers/database"
require "./controllers"
require "./images"
require "json"

module RmApi
  VERSION = "0.1.0"

  # Home page
  get "/" do
    render "src/client/home.ecr", "src/client/layouts/main.ecr"
  end

  # Get all travel plans
  get "/travel_plans" do |env|
    Controllers.get_all_plans(env)
  end

  # Get one plan
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

  # Append stop to travel plan
  patch "/travel_plans/:id/:stop" do |env|
    Controllers.append_stop(env)
  end

  # Get image url of location
  get "/location/image/:id" do |env|
    get_image_url(env)
  end

  Kemal.run
end
