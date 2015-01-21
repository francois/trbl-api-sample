require "representers/channel"
require "representers/show"
require "roar/decorator"
require "roar/json"

module Representer
  class ShowReport < Roar::Decorator
    include Roar::JSON

    property :market_code
    property :start_on
    property :interval

    collection :channels, extend: Representer::Channel
    collection :shows,    extend: Representer::Show
  end
end
