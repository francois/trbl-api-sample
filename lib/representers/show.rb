require "roar/decorator"
require "roar/json"

module Representer
  class Show < Roar::Decorator
    include Roar::JSON

    property :market_id
    property :show_id
    property :start_on
    property :interval

    property :name
    property :channel_ids

    property :score

    property :interactions_count
    property :participants_count
    property :impressions_count
    property :reach_count

    property :facebook_interactions_count
    property :facebook_participants_count
    property :facebook_impressions_count
    property :facebook_reach_count

    property :twitter_interactions_count
    property :twitter_participants_count
    property :twitter_impressions_count
    property :twitter_reach_count
  end
end
