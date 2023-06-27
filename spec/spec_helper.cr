require "spec"
require "../config"
require "./travel_stop_service_spec"
require "./travel_plan_service_spec"

  def log_test(log)
    return puts %Q(\n\n----------------------------------\n#{log}\n----------------------------------\n)
  end

  def log_success
    puts "		\033[92mPASSED\033[39m"
  end
