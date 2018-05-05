require 'weeb/api'
require 'uri'

module WeebSh
  module API
    # API endpoints for Shimakaze
    module Shimakaze
      BASE = '/reputation'.freeze

      module_function

      def get(interface, bot, user)
        WeebSh::API.request(
          :get,
          "#{interface.api_url}#{BASE}/#{bot}/#{user}",
          {
            Authorization: interface.auth,
            'User-Agent': interface.user_agent
          }
        )
      end

      def give(interface, bot, from, to)
        WeebSh::API.request(
          :post,
          "#{interface.api_url}#{BASE}/#{bot}/#{to}",
          {
            source_user: from
          }.to_json,
          {
            Authorization: interface.auth,
            'User-Agent': interface.user_agent
          }
        )
      end

      def reset(interface, bot, user, reset_cooldown = true)
        WeebSh::API.request(
          :post,
          "#{interface.api_url}#{BASE}/#{bot}/#{user}/reset",
          {
            cooldown: reset_cooldown
          }.to_json,
          {
            Authorization: interface.auth,
            'User-Agent': interface.user_agent
          }
        )
      end

      def increase(interface, bot, user, amount)
        WeebSh::API.request(
          :post,
          "#{interface.api_url}#{BASE}/#{bot}/#{user}/increase",
          {
            increase: amount
          }.to_json,
          {
            Authorization: interface.auth,
            'User-Agent': interface.user_agent
          }
        )
      end

      def decrease(interface, bot, user, amount)
        WeebSh::API.request(
          :post,
          "#{interface.api_url}#{BASE}/#{bot}/#{user}/decrease",
          {
            decrease: amount
          }.to_json,
          {
            Authorization: interface.auth,
            'User-Agent': interface.user_agent
          }
        )
      end

      def get_settings(interface)
        WeebSh::API.request(
          :get,
          "#{interface.api_url}#{BASE}/settings",
          {
            Authorization: interface.auth,
            'User-Agent': interface.user_agent
          }
        )
      end

      def set_settings(interface, settings)
        WeebSh::API.request(
          :post,
          settings.to_json,
          "#{interface.api_url}#{BASE}/settings",
          {
            Authorization: interface.auth,
            'User-Agent': interface.user_agent
          }
        )
      end
    end
  end
end
