require "./spec_helper"
require "../src/services/travel_plan_service"
require "json"


describe TravelPlanService do
  example_travel_stops = "[2,7,9,11,19]"
  updated_example_travel_stops = "[2,21,7,9,11,19]"
  example_travel_stops_optimized_to_test = "[19,9,2,11,7]"
  example_travel_stops_expanded_to_test = %Q("id":7,"name":"Immortality Field Resort","type":"Resort"})
    example_travel_plan_id = Int64.new(0)

    # POST
    it "create a travel plan" do
      log_test("TESTING | creating travel plan...")
      result = TravelPlanService.create_travel_plan(example_travel_stops)
      result.to_json.should contain(example_travel_stops)
      example_travel_plan_id = result.id
      log_success()
    end

    # GET
    it "get a travel plan" do
      parsed_id = example_travel_plan_id.to_s.to_i
      if parsed_id > 0
        log_test("TESTING | getting travel_plan...")
        result = TravelPlanService.get_travel_plan(parsed_id, nil, nil)
        result.to_json.should contain(example_travel_stops)
        log_success()
      else
        puts "Não pegou id"
      end
    end

    # GET ALL
    it "get all travel plans" do
      log_test("TESTING | getting all travel plans...")
      result = TravelPlanService.get_travel_plans(nil, nil)
      result.to_json.should contain(example_travel_stops)
      log_success()

    end

    it "get all travel plans expanded" do
      log_test("TESTING | getting all travel plans expanded...")
      result = TravelPlanService.get_travel_plans(true, nil)
      result.to_json.should contain("dimension")
      log_success()

    end

    it "get all travel plans optimized" do
      log_test("TESTING | getting all travel plans optimized...")
      result = TravelPlanService.get_travel_plans(nil, true)
      result.to_json.should contain(example_travel_stops_optimized_to_test)
      log_success()

    end


    it "get travel plan expanded & optimized " do
      parsed_id = example_travel_plan_id.to_s.to_i
      if parsed_id > 0
        log_test("TESTING | getting travel plan expanded & optimized...")
        result = TravelPlanService.get_travel_plan(parsed_id, true, true)
        parsed_result = JSON.parse(result.to_json)
        result.to_json.should contain("dimension")
        # correct optimized input is [0] item be eq 19
        parsed_result["travel_stops"][0]["id"].to_json.should contain("19")

        log_success()
      end
    end


    # UPDATE
    it "update a travel plan" do
      parsed_id = example_travel_plan_id.to_s.to_i
      if parsed_id > 0
        log_test("TESTING | updating travel plan...")
        result = TravelPlanService.update_travel_plan(parsed_id, updated_example_travel_stops)
        result.to_json.should contain(updated_example_travel_stops)
        log_success()
      else
        puts "Não pegou id"
      end
    end

    # DELETE
    it "delete a travel plan" do
      parsed_id = example_travel_plan_id.to_s.to_i
      if parsed_id > 0
        log_test("TESTING | deleting created travel plan...")
        result = TravelPlanService.delete_travel_plan(parsed_id)

        if result
          result.should be_a(DB::ExecResult)

          if result.rows_affected
            result.rows_affected.should eq(1)
          end
        end
        log_success()
      else
        puts "Não pegou id"
      end
    end


  end
