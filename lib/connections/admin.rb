require "sequel"
require "logging"
Sequel.extension(:core_extensions)

# Databases
params = {}
params[:logger] = ::LOGGER if ENV["VERBOSE"] == "yes"
ADB = Sequel.connect((ENV["ADMIN_DATABASE_URL"] || "postgres://localhost/svadmin_development").sub("jdbc:postgresql", "postgres"), params)
ADB.extension :pg_array
