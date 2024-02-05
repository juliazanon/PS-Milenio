require "kemal"

module RmApi
  VERSION = "0.1.0"

  get "/travel_plans" do
    plans = {id: 1, travel_stops: [1, 2]}
    plans.to_json
  end

  post "/travel_plans" do |env|
    id = env.params.json["id"]?.as(Int64)
    travel_stops = env.params.json["travel_stops"]?.as(Array)

    if !id
      error = {message: "must contain id"}.to_json
      halt env, status_code: 403, response: error
    end

    "Plan id #{id}, stops #{travel_stops}"
  end

  Kemal.run
end
