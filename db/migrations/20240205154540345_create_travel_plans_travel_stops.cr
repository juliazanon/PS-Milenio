# class CreateTravelPlansTravelStops < Jennifer::Migration::Base
#   def up
#     create_table :travel_plans_travel_stops do |t|
#       t.reference :travel_plan
#       t.reference :travel_stop
#     end
#   end

#   def down
#     drop_table :travel_plans_travel_stops if table_exists? :travel_plans_travel_stops
#   end
# end
