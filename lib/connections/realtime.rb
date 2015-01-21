require "sequel"
require "logging"
Sequel.extension(:core_extensions)

params = {}
params[:logger] = ::LOGGER if ENV["VERBOSE"] == "yes"
RDB = Sequel.connect((ENV["REALTIME_DATABASE_URL"] || "postgres://localhost/svrealtime_development").sub("jdbc:postgresql", "postgres"), params)
RDB.extension :pg_array
