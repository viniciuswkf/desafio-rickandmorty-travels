require "jennifer"
require "jennifer/adapter/postgres"

Jennifer::Config.configure do |conf|
  conf.logger = Log.for("db", nil)
  conf.from_uri("postgres://postgres:postgres@localhost:5432/rickandmorty_api")
end
