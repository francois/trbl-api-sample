require "rack/lint"
require "server"

use Rack::Lint
run Server
