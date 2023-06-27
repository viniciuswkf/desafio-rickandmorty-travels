require "./spec_helper"
require "../src/services/travel_stop_service"
require "json"

describe TravelStopService do
    # GET
    it "get all travel stops available" do
      log_test("TESTING | getting all available travel stops... (db/travel_stops_data.json)")
      travel_stops = TravelStopService.get_all_travel_stops()
      travel_stops_count = JSON.parse(travel_stops).size
      travel_stops_count.should be > 1
      puts "[INFO] Travel stops available: #{travel_stops_count} "
      log_success()
    end

end
