require 'weeb/interfaces/toph'
require 'weeb/interfaces/korra'
require 'weeb/interfaces/shimakaze'
require 'weeb/interfaces/tama'

module WeebSh
  # Wrapper class that ties all modules together
  class Client
    # @return [String] the authorization used in weeb.sh.
    attr_reader :auth

    # @return [String] the user agent used in weeb.sh.
    attr_reader :user_agent

    # @return [String] the URL being used for weeb.sh.
    attr_reader :api_url

    # @return [Topc] the toph class tied with the client.
    attr_reader :toph
    alias_method :image, :toph
    alias_method :images, :toph

    # @return [String] the korra class tied with the client.
    attr_reader :korra
    alias_method :image_gen, :korra
    alias_method :auto_image, :korra

    # @return [String] the shimakaze class tied with the client.
    attr_reader :shimakaze
    alias_method :reputation, :shimakaze
    alias_method :rep, :shimakaze

    # @return [String] the tama class tied with the client.
    attr_reader :tama
    alias_method :settings, :tama

    # Groups all interfaces into one.
    # @param auth [String] the authentication required to use weeb.sh.
    # @param user_agent [String, Hash] the user agent to use with requests.
    # @param api_url [String] the URL to use when using the weeb.sh API.
    def initialize(auth, user_agent = nil, api_url: 'https://api.weeb.sh')
      @user_agent = WeebSh::API.format_user_agent(user_agent)
      @auth = auth
      @api_url = api_url

      raise WeebSh::Err::BadAuth, 'Authorization is empty!' if auth.empty?
      puts '[WeebSh::Client] Your User Agent is empty. Please consider adding a user agent to help identify issues easier.' if user_agent.nil?
      puts '[WeebSh::Client] Your User Agent is not ideal. Please consider adding a user agent to help identify issues easier.' if !user_agent.nil? && user_agent.split('/').count < 2

      @toph = WeebSh::Toph.new(auth, user_agent, api_url: api_url, client: self)
      @korra = WeebSh::Korra.new(auth, user_agent, api_url: api_url, client: self)
      @shimakaze = WeebSh::Shimakaze.new(auth, user_agent, api_url: api_url, client: self)
      @tama = WeebSh::Tama.new(auth, user_agent, api_url: api_url, client: self)
    end

    def user_agent=(user_agent)
      @user_agent = user_agent
      @toph.user_agent = user_agent
      @korra.user_agent = user_agent
      @shimakaze.user_agent = user_agent
      @tama.user_agent = user_agent
    end

    def auth=(auth)
      @auth = auth
      @toph.auth = auth
      @korra.auth = auth
      @shimakaze.auth = auth
      @tama.auth = auth
    end

    def api_url=(api_url)
      @api_url = api_url
      @toph.api_url = api_url
      @korra.api_url = api_url
      @shimakaze.api_url = api_url
      @tama.api_url = api_url
    end

    def inspect
      "#<WeebSh::Client @api_url=#{@api_url.inspect} @user_agent=#{@user_agent.inspect}>"
    end
  end
end
