require "sequel"
require "sequel/extensions/pg_array"
require "logging"
Sequel.extension(:core_extensions)

# Databases
database_url = (ENV["SVANINTERACTIVE_DATABASE_URL"] || "postgres://localhost/svanalytics_development").sub("jdbc:postgresql", "postgres")

params = {}
params[:logger]          = ::LOGGER if ENV["VERBOSE"] == "yes"
params[:after_connect]   = lambda {|conn| LOGGER.info {"Connected to #{conn.class.name.sub("::Adapter", "").split("::").last.downcase}://#{conn.user}@#{conn.host}:#{conn.port}/#{conn.db}"}}
params[:max_connections] = (ENV["DATABASE_CONCURRENCY_LIMIT"] || 1).to_i
params[:pool_sleep_time] = 2.0  # Try every 2 seconds to see if a connection is available
params[:pool_timeout]    = 7200 # Wait up to 2 hours before giving up and saying we couldn't get a connection

MDB = Sequel.connect(database_url, params)
MDB.extension :pg_array
