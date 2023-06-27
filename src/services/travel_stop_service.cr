require "http/client"
require "json"


# Essa foi a forma que eu encontrei de conseguir os dados e ordenar usando
# ... a CRYSTAL LANG (Uma das partes mais desafiadoras do projeto, por eu nunca ter ouvido falar dela)
# # Realizei um Web Scrape da API pública Rick And Morty API


module TravelStopService
  extend self

  def get_all_travel_stops()
    database = File.read(File.join(File.dirname(__FILE__), "..",  "..", "db",  "travel_stops_data.json"))
    database
  end

  def get_locations_details_by_ids(location_ids)

    filtered_locations = Array(JSON::Any).new

    database = get_all_travel_stops()

    Array(Int32).from_json(location_ids.to_s).each do |location_id|
      filtered_data = Array(JSON::Any).from_json(database).select do |item|
        JSON.parse(item["id"].to_s.to_i.to_json)  == location_id
      end
      filtered_locations << filtered_data.first
    end

    ## converter id do travel_stop para inteiro
    parsed_filtered_locations = Array(Hash(String, JSON::Any)).from_json(filtered_locations.to_json)
    locations_result = parsed_filtered_locations.map do |travel_stop_details|
      travel_stop_details["id"] = JSON.parse(travel_stop_details["id"].to_s.to_i.to_json)
      travel_stop_details
    end

    locations_result
  end

  def get_details_of_many_travels_plans(travel_plans, expand, optimize)
    new_travels_with_details = Array(JSON::Any).new

    travel_plans.each do |plan|

      locations = self.get_locations_details_by_ids(plan["travel_stops"])
      locations_optimized_and_expanded = self.expand_and_optimize(locations, expand, optimize)
      new_travels_with_details << JSON.parse({"id" => plan["id"].to_s.to_i, "travel_stops"=> locations_optimized_and_expanded}.to_json)
    end

    new_travels_with_details
  end




  # # Se baseia no número de aparição de cada dimensão, e calcula a popução
  # # Converte para ordem crescente de popularidade.
  def sort_by_location_popularity(locations : Array(Hash(String, JSON::Any))) : Array(Hash(String, JSON::Any))
    dimension_counts = Hash(String, Int32).new(0)

    locations.each do |location|
      dimension = location["dimension"].to_s
      dimension_counts[dimension] += 1
    end

    sorted_dimensions = dimension_counts.keys.sort_by { |dimension| -dimension_counts[dimension] }.reverse

    locations.sort do |a, b|
      dimension_a = a["dimension"].to_s
      dimension_b = b["dimension"].to_s

      popularity_a = calculate_location_popularity(a)
      popularity_b = calculate_location_popularity(b)

      index_a = sorted_dimensions.index(dimension_a)
      index_b = sorted_dimensions.index(dimension_b)

      if index_a.nil? || index_b.nil?
        index_a.nil? ? -1 : 1
      else
        if index_a < index_b
          -1
        elsif index_a > index_b
          1
        else
          if popularity_a < popularity_b
            -1
          elsif popularity_a > popularity_b
            1
          else
            a["name"].to_s <=> b["name"].to_s
          end
        end
      end
    end
  end

  # Calcula a popularidade de uma localização
  # Baseado em: número de aparições dos seus residentes
  def calculate_location_popularity(location : Hash(String, JSON::Any)) : Int32
    location["residents_episodes_count"].to_s.to_i
  end


  # # Expande e otimiza as paradas da viagem
  # # Somente se requerido
  def expand_and_optimize(locations, expand, optimize)
    parsed_results = nil

    if expand && !optimize
      ## expand=true
      locations.each do |location| # De cada loc.
        # Remove parâmetros internos de contagem
        location.delete("residents")
        location.delete("residents_episodes_count")
        location["id"] = JSON.parse(location["id"].to_s.to_i.to_json)
      end
      locations
    else
      if expand && optimize
        ## expand=true optimize=true
        expanded_optimized_locations = sort_by_location_popularity(locations)
        expanded_optimized_locations.each do |location|
          location.delete("residents_episodes_count")
          location["id"] = JSON.parse(location["id"].to_s.to_i.to_json)
        end

        expanded_optimized_locations
      else
        if !expand && optimize
          ## optimize=true
          optimized_locations = sort_by_location_popularity(locations)
          optimized_locations.map { |locat| locat["id"].to_s.to_i rescue 0 }
        else
          ##
          normal_locations = Array(JSON::Any).new
          locations.each do |key|
            normal_locations << JSON.parse(key["id"].as_s.to_i.to_json)
          end
          normal_locations
        end
      end
    end
  end


end
