require "jennifer"
# require "./travel_plan"

class TravelStop < Jennifer::Model::Base
  with_timestamps

  mapping(
    id: Primary32,
    name: String,
    type: String,
    dimension: String,
    created_at: Time?,
    updated_at: Time?,
  )

  # has_and_belongs_to_many :travel_plans, TravelPlan
end
