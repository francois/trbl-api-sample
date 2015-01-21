require "roar/decorator"
require "roar/json"

module Representer
  class Channel < Roar::Decorator
    include Roar::JSON

    property :channel_id
    property :name
  end
end
