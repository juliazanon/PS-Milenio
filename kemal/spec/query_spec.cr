require "./spec_helper"
require "../src/models/travel_plan"
require "../src/controllers"
# require "webmock"

###############
# Query tests #
###############

# def test_get_all_plans_without_params
#   # Arrange
#   WebMock.stub(:get, "http://localhost:3000/travel_plans")
#   stub_response = JSON.parse({[{"id": 1, "travel_stops": [1, 2, 3]}]})
#   WebMock.register_response(body: stub_response.to_json)

#   # Act
#   response = Controllers.get_all_plans(false, false)

#   # Assert
#   assert_equal stub_response.to_json, response
# end

# describe Controllers do
#   describe "get_all_plans" do
#     it "..." do
#       WebMock.stub 

#       end
#     end
#   end
# end
