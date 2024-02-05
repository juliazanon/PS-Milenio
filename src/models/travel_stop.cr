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
end
