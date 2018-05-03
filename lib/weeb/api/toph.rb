require 'weeb/api'
require 'uri'

module WeebSh
  module API
    # API endpoints for Toph
    module Toph
      BASE = '/images'.freeze

      module_function

      def upload(interface, resource, type, hidden, tags, nsfw, source)
        resource.is_a?(File) ? WeebSh::API.request(
          :post,
          "#{interface.api_url}#{BASE}/upload",
          {
            'file'.to_sym => resource,
            'baseType'.to_sym => type,
            'hidden'.to_sym => hidden,
            'tags'.to_sym => tags,
            'nsfw'.to_sym => nsfw,
            'source'.to_sym => source
          },
          {
            Authorization: interface.auth,
            'User-Agent': interface.user_agent
          }
        ) : WeebSh::API.request(
          :post,
          "#{interface.api_url}#{BASE}/upload",
          {
            url: resource,
            baseType: type,
            hidden: hidden,
            tags: tags,
            nsfw: nsfw,
            source: source
          }.to_json,
          {
            Authorization: interface.auth,
            'User-Agent': interface.user_agent
          }
        )
      end

      def types(interface, query)
        WeebSh::API.request(
          :get,
          "#{interface.api_url}#{BASE}/types?#{URI.encode_www_form(query)}",
          {
            Authorization: interface.auth,
            'User-Agent': interface.user_agent
          }
        )
      end

      def tags(interface, query)
        WeebSh::API.request(
          :get,
          "#{interface.api_url}#{BASE}/tags?#{URI.encode_www_form(query)}",
          {
            Authorization: interface.auth,
            'User-Agent': interface.user_agent
          }
        )
      end

      def random(interface, query)
        WeebSh::API.request(
          :get,
          "#{interface.api_url}#{BASE}/random?#{URI.encode_www_form(query)}",
          {
            Authorization: interface.auth,
            'User-Agent': interface.user_agent
          }
        )
      end

      def image(interface, id)
        WeebSh::API.request(
          :get,
          "#{interface.api_url}#{BASE}/info/#{id}",
          {
            Authorization: interface.auth,
            'User-Agent': interface.user_agent
          }
        )
      end

      def add_tags_to_image(interface, id, tags)
        WeebSh::API.request(
          :post,
          "#{interface.api_url}#{BASE}/info/#{id}",
          { tags: tags }.to_json,
          {
            Authorization: interface.auth,
            'User-Agent': interface.user_agent
          }
        )
      end

      def remove_tags_to_image(interface, id, tags)
        WeebSh::API.request(
          :delete,
          "#{interface.api_url}#{BASE}/info/#{id}",
          { tags: tags }.to_json,
          {
            Authorization: interface.auth,
            'User-Agent': interface.user_agent
          }
        )
      end

      def remove_image(interface, id)
        WeebSh::API.request(
          :delete,
          "#{interface.api_url}#{BASE}/info/#{id}",
          {
            Authorization: interface.auth,
            'User-Agent': interface.user_agent
          }
        )
      end

      def list(interface, query)
        WeebSh::API.request(
          :get,
          "#{interface.api_url}#{BASE}/list?#{URI.encode_www_form(query)}",
          {
            Authorization: interface.auth,
            'User-Agent': interface.user_agent
          }
        )
      end

      def list_user(interface, id, query)
        WeebSh::API.request(
          :get,
          "#{interface.api_url}#{BASE}/list/#{id}?#{URI.encode_www_form(query)}",
          {
            Authorization: interface.auth,
            'User-Agent': interface.user_agent
          }
        )
      end
    end
  end
end
