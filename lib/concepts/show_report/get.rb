require "connections/realtime"
require "ostruct"
require "reform/form"
require "reform/form/coercion"
require "trailblazer/operation"

module ShowReport
  class Get < Trailblazer::Operation
    contract do
      include Coercion

      property :market_code
      property :interval
      property :start_on, type: Date

      validates :interval, inclusion: {in: %w(1d 1w), message: "is invalid; only '1d' and '1w' are valid values"}
      validates :market_code, inclusion: RDB[:active_show_markets].select_map(:short_name)
    end

    attr_reader :channels, :shows, :market_id, :interval, :market_code, :start_on

    def process(params)
      validate(params, OpenStruct.new) do |form|
        market = RDB[:markets].
          filter(short_name: form.market_code).
          first

        show_reports_params = {
          start_on: form.start_on,
          market_id: market.fetch(:market_id),
          valid_starting_on: Date.new(2011, 8, 29),
          interval: form.interval
        }

        shows = RDB[show_reports_sql, show_reports_params].to_a

        channels_params = {
          market_id: market.fetch(:market_id),
          channel_ids: shows.map{|show| show.fetch(:channel_ids)}.flatten.uniq
        }
        channels = RDB[channels_sql, channels_params].to_a

        @channels    = channels.map{|channel| OpenStruct.new(channel)}
        @shows       = shows.map{|show| OpenStruct.new(show)}
        @market_id   = market.fetch(:market_id)
        @interval    = form.interval
        @market_code = form.market_code
        @start_on    = form.start_on
      end
    end

    private

    def show_reports_sql
      <<-EOSQL
        SELECT
            market_id
          , show_id
          , ((start_at AT TIME ZONE 'Etc/UTC') AT TIME ZONE markets.timezone) start_on
          , interval :interval "interval"

          , shows.name AS name
          , channel_ids
          , score

          , interactions_count
          , participants_count
          , impressions_count
          , social_reach reach_count

          , facebook_interactions_count
          , facebook_participants_count
          , facebook_impressions_count
          , 0::bigint facebook_reach_count

          , twitter_interactions_count
          , twitter_participants_count
          , twitter_impressions_count
          , social_reach twitter_reach_count

        FROM   browse_show_reports(date :start_on, date :start_on, uuid :market_id, interval :interval, date :valid_starting_on) t1
          JOIN markets USING (market_id)
          JOIN shows   USING (show_id)
        ORDER BY interactions_count DESC
      EOSQL
    end

    def channels_sql
      <<-EOSQL
        SELECT
            channel_id
          , channels.name AS name
        FROM   channels
          JOIN channel_market_memberships USING (channel_id)
        WHERE market_id = :market_id
          AND channel_id IN :channel_ids
        ORDER BY lower(channels.name)
      EOSQL
    end
  end
end
