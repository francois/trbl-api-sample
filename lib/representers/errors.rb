require "roar/decorator"
require "roar/json"

module Representer
  class Errors < Roar::Decorator
    include Roar::JSON

    property :code
    collection :errors
  end
end
