require "kemal"





# # VIEW ROUTES (SCREENS)

get "/" do |env|
  env.response.content_type = "text/html"
  render "src/views/screens/index_travel_plan.html"
end

get "/create" do |env|
  env.response.content_type = "text/html"
  render "src/views/screens/create_travel_plan.html"
end

get "/travel_plan/:id" do |env|
  env.response.content_type = "text/html"
  render "src/views/screens/show_travel_plan.html"
end

get "/update/:id" do |env|
  env.response.content_type = "text/html"
  render "src/views/screens/update_travel_plan.html"
end

get "/documentation" do |env|
  env.response.content_type = "text/html"
  render "src/views/screens/_documentation.html"
end


# IMG

get "/img/header.jpeg" do |env|
  env.response.content_type = "image/jpeg"
  render "src/views/public/img/header.jpeg"
end

# CSS

get "/css/main.css" do |env|
  env.response.content_type = "text/css"
  render "src/views/public/css/main.css"
end

# JS
get "/js/create_travel_plan.js" do |env|
  env.response.content_type = "text/javascript"
  render "src/views/public/js/create_travel_plan.js"
end
get "/js/index_travel_plan.js" do |env|
  env.response.content_type = "text/javascript"
  render "src/views/public/js/index_travel_plan.js"
end
get "/js/show_travel_plan.js" do |env|
  env.response.content_type = "text/javascript"
  render "src/views/public/js/show_travel_plan.js"
end
get "/js/update_travel_plan.js" do |env|
  env.response.content_type = "text/javascript"
  render "src/views/public/js/update_travel_plan.js"
end
