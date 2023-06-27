require "../services/travel_plan_service"

module TravelPlanController
  extend self
  include TravelPlanService

  def all(env)
    expand = env.params.query.try &.fetch("expand", nil)
    optimize = env.params.query.try &.fetch("optimize", nil)
    TravelPlanService.get_travel_plans(expand, optimize).to_json
  end

  def show(env)
    travel_plan_id = env.params.url["id"]

    expand = env.params.query.try &.fetch("expand", nil)
    optimize = env.params.query.try &.fetch("optimize", nil)
    # JSON.parse(result)["id"].to_json).to_s.to_i
    begin
      TravelPlanService.get_travel_plan(JSON.parse(travel_plan_id.to_json).to_s.to_i, expand, optimize).to_json
    rescue e : Exception
      env.response.status_code = 404
    end
  end

  def create(env)
    travel_stops = env.params.json["travel_stops"].to_json

    begin
      TravelPlanService.create_travel_plan(travel_stops).to_json
    rescue e : Exception
      env.response.status_code = 500
    end
  end

  def delete(env)
    id = env.params.url["id"]
    begin
      TravelPlanService.delete_travel_plan(id)
    rescue ex
      env.response.status_code = 500
    end
  end

  def update(env)
    id = env.params.url["id"]
    travel_stops = env.params.json["travel_stops"].to_json
    begin
      TravelPlanService.update_travel_plan(id, travel_stops).to_json
    rescue ex
      env.response.status_code = 500
    end
  end
end
