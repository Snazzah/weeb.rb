require 'weeb/api'
require 'uri'

module WeebSh
  module API
    # API endpoints for Korra
    module Korra
      BASE = '/auto-image'.freeze

      module_function

      def discord_status(interface, query)
        WeebSh::API.request(
          :get,
          "#{interface.api_url}#{BASE}/discord-status?#{URI.encode_www_form(query)}",
          {
            Authorization: interface.auth,
            'User-Agent': interface.user_agent
          }
        )
      end

      def simple(interface, query)
        WeebSh::API.request(
          :get,
          "#{interface.api_url}#{BASE}/generate?#{URI.encode_www_form(query)}",
          {
            Authorization: interface.auth,
            'User-Agent': interface.user_agent
          }
        )
      end

      def license(interface, title, avatar, badges, widgets)
        WeebSh::API.request(
          :post,
          "#{interface.api_url}#{BASE}/license",
          {
            title: title,
            avatar: avatar,
            badges: badges,
            widgets: widgets
          }.to_json,
          {
            Authorization: interface.auth,
            'User-Agent': interface.user_agent
          }
        )
      end

      def waifu_insult(interface, url)
        WeebSh::API.request(
          :post,
          "#{interface.api_url}#{BASE}/waifu-insult",
          { avatar: url }.to_json,
          {
            Authorization: interface.auth,
            'User-Agent': interface.user_agent
          }
        )
      end

      def love_ship(interface, target1, target2)
        WeebSh::API.request(
          :post,
          "#{interface.api_url}#{BASE}/love-ship",
          {
            targetOne: target1,
            targetTwo: target2
          }.to_json,
          {
            Authorization: interface.auth,
            'User-Agent': interface.user_agent
          }
        )
      end
    end
  end
end
