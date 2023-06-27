require "./controllers/travel_plan_controller"
require "./controllers/travel_stop_controller"

module Routes
  include TravelPlanController
  include TravelStopController

  # # /travel_stops -  db/travel_stops_data.json
  get "/travel_stops" do |env|
    TravelStopController.all
  end


  get "/travel_plans" do |env|
    TravelPlanController.all(env)
  end

  get "/travel_plans/:id" do |env|
    TravelPlanController.show(env)
  end

  post "/travel_plans" do |env|
    TravelPlanController.create(env)
  end

  delete "/travel_plans/:id" do |env|
    TravelPlanController.delete(env)
  end

  put "/travel_plans/:id" do |env|
    TravelPlanController.update(env)
  end
end
