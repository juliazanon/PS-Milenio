require "jennifer"
# require "./travel_stop"

class TravelPlan < Jennifer::Model::Base
  mapping(
    id: Primary32,
    travel_stops: Array(Int32),
  )

  # has_and_belongs_to_many :travel_stops, TravelStop
end
