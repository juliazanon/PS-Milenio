require "jennifer"
# require "./travel_stop"

class TravelPlan < Jennifer::Model::Base
  with_timestamps

  mapping(
    id: Primary32,
    travel_stops: Array(Int32),
    created_at: Time?,
    updated_at: Time?,
  )

  # has_and_belongs_to_many :travel_stops, TravelStop
end
