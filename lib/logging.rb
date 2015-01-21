require "logger"

begin
  require "debugger"
rescue LoadError
  # NOP: Ignore in non-dev environment
end

# Respect the command-line parameters
ENV["QUIET"]   = ARGV.delete("--quiet")   ? "yes" : ENV["QUIET"]
ENV["VERBOSE"] = ARGV.delete("--verbose") ? "yes" : ENV["VERBOSE"]

# Then use that information to correctly configure the logger
unless Object.const_defined?(:LOGGER)
  LOGGER = Logger.new(STDERR)
  LOGGER.level = if ENV["VERBOSE"] == "yes" && ENV["QUIET"] == "yes" then
                   Logger::INFO
                 elsif ENV["VERBOSE"] == "yes"
                   Logger::DEBUG
                 elsif ENV["QUIET"] == "yes"
                   Logger::ERROR
                 else
                   Logger::INFO
                 end
  LOGGER.formatter = lambda {|severity, datetime, progname, msg|
    "[#{"%-5s" % severity}] #{File.basename($0)}:#{Process.pid} - #{msg}\n"
  }
end

def logger
  LOGGER
end
