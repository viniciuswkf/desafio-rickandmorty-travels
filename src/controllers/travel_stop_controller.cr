require "../services/travel_stop_service"

module TravelStopController

  extend self
  include TravelStopService

  def all
    TravelStopService.get_all_travel_stops()
  end
  
end
