require 'weeb/err'
require 'weeb/ver'
require 'uri'
require 'json'
require 'rest-client'

module WeebSh
  # Main API functions
  module API
    module_function

    def request(type, *attributes)
      parse_json(RestClient.send(type, *attributes))
    rescue RestClient::RequestEntityTooLarge
      raise WeebSh::Err::TooLarge, 'Requested files are too large!'
    rescue RestClient::Unauthorized => e
      json = parse_json(e.response)
      if json.is_a?(Hash)
        raise WeebSh::Err::BadAuth, 'Token is invalid!' if json['message'] == 'Unauthorized'
      end
    rescue RestClient::BadRequest => e
      json = parse_json(e.response)
      if json.is_a?(Hash)
        raise WeebSh::Err::InvalidMIME, json['message'] if json['message'].start_with? 'The mimetype'
        raise WeebSh::Err::TagExists, json['message'] if json['message'] == 'Tags existed already or had no content'
        raise WeebSh::Err::ImagePrivate, json['message'] if json['message'] == 'This image is private'
        raise WeebSh::Err::InvalidImage, json['message'] if json['message'] == 'No image found for your query'
      end
      raise e
    rescue RestClient::Forbidden => e
      json = parse_json(e.response)
      if json.is_a?(Hash)
        raise WeebSh::Err::MissingScope, json['message'] if json['message'].start_with? 'missing scope'
      end
      raise e
    rescue RestClient::InternalServerError
      raise WeebSh::Err::ServerFail, 'Server Error!'
    rescue RuntimeError => e
      raise e
    end

    def format_user_agent(user_agent)
      user_agent = "#{user_agent['botname']}/#{user_agent['version']}#{"/#{user_agent['env']}" if user_agent['env']}" if user_agent.is_a?(Hash)
      return nil unless user_agent.is_a?(String) && !user_agent.empty?
      user_agent
    end

    def parse_json(raw)
      JSON.parse(raw)
    rescue JSON::ParserError
      raw
    end
  end
end
