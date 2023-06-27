require "../models/travel_plan"
require "./travel_stop_service"
require "jennifer"

module TravelPlanService
  extend self
  include TravelStopService

  def get_travel_plans(expand, optimize)
    travel_plans = TravelPlan.all

    if expand.nil? || (expand.is_a?(String) && expand == "")
      if optimize.nil? || (optimize.is_a?(String) && optimize == "")
        return travel_plans
      end
    end

    travel_plans_filtered = TravelStopService.get_details_of_many_travels_plans(Array(JSON::Any).from_json(travel_plans.to_json), expand, optimize)
    travel_plans_filtered
  end

  def create_travel_plan(travel_stops)
    if typeof(travel_stops) != JSON::Any
      {"error": "invalid input"}
    end
    travel_plan = TravelPlan.create(travel_stops: travel_stops)
    travel_plan
  end

  def delete_travel_plan(id)
    TravelPlan.find!(id)
    TravelPlan.delete(id)
  end

  def update_travel_plan(id, travel_stops)
    travel = TravelPlan.find!(id)

    TravelPlan.where { _id == id }.update(travel_stops: travel_stops)
    travel.reload
    travel
  end

  def get_travel_plan(id : Int32, expand, optimize)
    if typeof(id) == nil
      return {"error": "Missing ID"}
    else
      travel_plan = TravelPlan.find!(id)

      if expand.nil? || (expand.is_a?(String) && expand == "")
        if optimize.nil? || (optimize.is_a?(String) && optimize == "")
          return travel_plan
        end
      end

      locations_details = TravelStopService.get_locations_details_by_ids(travel_plan.travel_stops)
      details_expanded_optimized = TravelStopService.expand_and_optimize(locations_details, expand, optimize)

      {"id": id.to_i, "travel_stops": details_expanded_optimized}
    end
  end
end
