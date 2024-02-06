require "jennifer"
require "jennifer/adapter/postgres"

module DBConfig
  extend self

  APP_ENV      = ENV["APP_ENV"]? || "development"
  DATABASE_URI = "localhost:5432"

  Jennifer::Config.configure do |conf|
    conf.read("config/database.yml", APP_ENV)
    conf.from_uri(ENV[DATABASE_URI]) if ENV.has_key?(DATABASE_URI)
    conf.logger.level = APP_ENV == "development" ? Log::Severity::Debug : Log::Severity::Error
  end

  Log.setup "db", Log::Severity::Debug, Log::IOBackend.new(formatter: Jennifer::Adapter::DBFormatter)
end
