require "jennifer"

class TravelPlan < Jennifer::Model::Base
  mapping(
    id: Primary32,
    travel_stops: Array(Int32),
  )
end
