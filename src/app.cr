require "kemal"
require "../config/*"
require "./routes"
require "./views/views_routes"

#cors
static_headers do |response, filepath, filestat|
  response.headers.add("Access-Control-Allow-Origin", "*")
  response.headers.add("Content-Size", filestat.size.to_s)
end

module Rickandmorty::Travels::Api
add_handler Kemal::StaticFileHandler.new("/css", "public/css")

# Serve JS files
add_handler Kemal::StaticFileHandler.new("/js", "public/js")

  Kemal.run
end
