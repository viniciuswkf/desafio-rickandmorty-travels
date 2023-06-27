

class TravelPlan < Jennifer::Model::Base
  mapping(
    id: Primary64,
    travel_stops: JSON::Any,
  )
end
