require 'weeb/api'
require 'time'

module WeebSh
  # Mixin for objects with IDs
  module IDObject
    # @return [String] the ID which uniquely identifies this object in toph.
    attr_reader :id
    alias_method :resolve_id, :id
    alias_method :hash, :id

    # ID based comparison
    def ==(other)
      other.respond_to?(:resolve_id) ? (@id.resolve_id == other.resolve_id) : (@id == other)
    end
  end

  # Represents a generic interface
  class Interface
    # @return [String] the authorization used in weeb.sh.
    attr_accessor :auth

    # @return [String] the user agent used in weeb.sh.
    attr_accessor :user_agent

    # @return [String] the URL being used for weeb.sh.
    attr_reader :api_url

    # @param auth [String] the authentication required to use weeb.sh.
    # @param user_agent [String, Hash] the user agent to use on endpoints.
    # @param api_url [String] the URL to use when using the weeb.sh API.
    # @param client [Client] the client this is tied to.
    def initialize(auth, user_agent = nil, api_url: 'https://api.weeb.sh', client: nil)
      @user_agent = WeebSh::API.format_user_agent(user_agent)
      @auth = auth
      @api_url = api_url
      @client = client

      return if client
      raise WeebSh::Err::BadAuth, 'Authorization is empty!' if auth.empty?
      puts "[#{self.class.name}] Your User Agent is empty. Please consider adding a user agent to help identify issues easier." if user_agent.nil?
      puts "[#{self.class.name}] Your User Agent is not ideal. Please consider adding a user agent to help identify issues easier." if !user_agent.nil? && user_agent.split('/').count < 2
    end

    # @!visibility private
    def inspect
      "#<#{self.class.name} @api_url=#{@api_url.inspect} @user_agent=#{@user_agent.inspect}>"
    end
  end

  # Represents a preview image for toph
  class PreviewImage
    include IDObject

    # @return [Symbol] the type of image this is
    attr_reader :type

    # @return [String] the file extension of the image
    attr_reader :file_type

    # @return [String] the url of the image
    attr_reader :url

    # @!visibility private
    def initialize(data, interface)
      @interface = interface
      @id = data['id']
      @type = data['type']
      @file_type = data['fileType']
      @url = data['url']
    end

    # @!visibility private
    def inspect
      "#<WeebSh::PreviewImage @url=#{@url.inspect} @type=#{@type.inspect}>"
    end
  end

  # Represents an image for toph
  class WeebImage < PreviewImage
    # @return [true, false] whether or not this image is nsfw
    attr_reader :nsfw
    alias_method :nsfw?, :nsfw

    # @return [String] the mime type of the image
    attr_reader :mime_type

    # @return [Array<String>] the tags on image
    attr_reader :tags

    # @return [true, false] whether or not this image can only be seen by the uploader
    attr_reader :hidden
    alias_method :hidden?, :hidden

    # @return [String, nil] the source of the image
    attr_reader :source

    # @return [String] the ID of the uploader
    attr_reader :account
    alias_method :uploader, :account
    alias_method :author, :account

    # @!visibility private
    def initialize(data, interface)
      @interface = interface
      @id = data['id']
      @type = data['type']
      @nsfw = data['nsfw']
      @file_type = data['fileType']
      @mime_type = data['mimeType']
      @url = data['url']
      @hidden = data['hidden']
      @file_type = data['fileType']
      @source = data['source'] || nil
      @account = data['account']
      @tags = data['tags'].map { |r| Tag.new(r, interface) }
    end

    # Add tags to the image
    # @param tags [Array<String, Tag>] the affected tags
    def add_tags(tags)
      @interface.add_tags_to_image(self, tags)
    end

    # Remove tags from the image
    # @param tags [Array<String, Tag>] the affected tags
    def remove_tags(tags)
      @interface.remove_tags_to_image(self, tags)
    end

    # Add a tag to the image
    # @param tag [String, Tag] the affected tag
    def add_tag(tag)
      @interface.add_tags_to_image(self, [tag])
    end

    # Remove a tag to the image
    # @param tag [String, Tag] the affected tag
    def remove_tag(tag)
      @interface.remove_tags_to_image(self, [tag])
    end

    # Delete this image
    def delete
      @interface.delete_image(self)
    end
    alias_method :remove, :delete

    # @!visibility private
    def inspect
      "#<WeebSh::WeebImage @url=#{@url.inspect} @type=#{@type.inspect} @nsfw=#{@nsfw.inspect}>"
    end
  end

  # Represents an Image tag for toph
  class Tag
    # @return [String] the name of the tag
    attr_reader :name

    # @return [true, false] whether or not this tag can only be seen by the uploader
    attr_reader :hidden
    alias_method :hidden?, :hidden

    # @return [String] the ID of the creator
    attr_reader :account
    alias_method :creator, :account
    alias_method :author, :account

    # @!visibility private
    def initialize(data, interface)
      @interface = interface
      @name = data['name']
      @hidden = data['hidden']
      @account = data['account']
    end

    # @!visibility private
    def inspect
      "#<WeebSh::Tag @name=#{@name.inspect} @hidden=#{@hidden.inspect} @account=#{@account.inspect}>"
    end
  end

  # Represents a user for shimakaze
  class User
    include IDObject

    # @return [Integer] the reputation of the user
    attr_reader :reputation
    alias_method :rep, :reputation

    # @return [String] the ID of the bot that issues reputation
    attr_reader :bot_id

    # @return [String] the ID of the account from the token
    attr_reader :account

    # @return [Array<Time>] the last time(s) this user has given reputation to another user
    attr_reader :cooldown
    alias_method :taken_reputation, :cooldown

    # @return [Array<Time>] the last time(s) this user has received reputation from another user
    attr_reader :given_reputation

    # @return [Integer, nil] the amount to times the user may give reputation
    attr_reader :available_reputation

    # @return [Array<Time>, nil] the timestamps referring to the remaining cooldown time until the user can give out reputation from now
    attr_reader :next_available_reputation

    # @!visibility private
    def initialize(data, interface)
      @interface = interface
      patch(data)
      @available_reputation = data['availableReputation']
      @next_available_reputation = data['nextAvailableReputation'] ? data['nextAvailableReputation'].map { |t| Time.parse(t) } : nil
    end

    # Increases the user's reputation
    # @param amount [Integer] the amount of reputation that will increase
    # @return [User] the class itself
    def increase(amount)
      response = WeebSh::API::Shimakaze.increase(@interface, @bot_id, @id, amount)
      patch(response['user'])
      self
    end

    # Decreases the user's reputation
    # @param amount [Integer] the amount of reputation that will decrease
    # @return [User] the class itself
    def decrease(amount)
      response = WeebSh::API::Shimakaze.decrease(@interface, @bot_id, @id, amount)
      patch(response['user'])
      self
    end

    # Resets the user
    # @return [User] the class itself
    def reset
      response = WeebSh::API::Shimakaze.reset(@interface, @bot_id, @id)
      patch(response['user'])
      self
    end

    # Gives reputation to another user
    # @Param user [User, String, #resolve_id] the user to give reputation to
    # @return [User] the class itself
    def give(user)
      user_id = user.resolve_id if user.respond_to?(:resolve_id)
      response = API::Shimakaze.give(@interface, @bot_id, @id, user_id || user)
      patch(response['sourceUser'])
      user.patch(response['targetUser']) if user.is_a?(User)
      self
    end

    # Recieves reputation to another user
    # @Param user [User, String, #resolve_id] the user to get reputation from
    # @return [User] the class itself
    def recieve(user)
      user_id = user.resolve_id if user.respond_to?(:resolve_id)
      response = API::Shimakaze.give(@interface, @bot_id, user_id || user, @id)
      patch(response['targetUser'])
      user.patch(response['sourceUser']) if user.is_a?(User)
      self
    end

    # @!visibility private
    def patch(data)
      @reputation = data['reputation']
      @id = data['userId']
      @bot_id = data['botId']
      @account = data['account']
      @cooldown = data['cooldown'].map { |t| Time.parse(t) }
      @given_reputation = data['givenReputation'].map { |t| Time.parse(t) }
      @available_reputation = data['availableReputation'] if data['availableReputation'].nil?
      @next_available_reputation = data['nextAvailableReputation'].map { |t| Time.parse(t) } if data['nextAvailableReputation'].nil?
    end

    # @!visibility private
    def inspect
      "#<WeebSh::User @reputation=#{@reputation.inspect} @id=#{@id.inspect} @bot_id=#{@bot_id.inspect}>"
    end
  end

  # Represents a reputation settings object for shimakaze
  class ReputationSettings
    include IDObject

    # @return [Integer] the number of reputations a user may give out per cooldown
    attr_accessor :reputation_per_day
    alias_method :rep_per_day, :reputation_per_day

    # @return [Integer] the maximum reputation a user may receive
    attr_accessor :max_reputation
    alias_method :max_rep, :max_reputation

    # @return [Integer] the maximum reputation a user may receive per day
    attr_accessor :max_reputation_per_day
    alias_method :max_rep_per_day, :max_reputation_per_day

    # @return [Integer] the cooldown per reputation, this is set to time in seconds
    attr_accessor :reputation_cooldown
    alias_method :rep_cooldown, :reputation_cooldown

    # @return [String, nil] the ID of the account from the token
    attr_accessor :account

    # @!visibility private
    def initialize(data, interface)
      @interface = interface
      @reputation_per_day = data['reputationPerDay']
      @max_reputation = data['maximumReputation']
      @max_reputation_per_day = data['maximumReputationReceivedDay']
      @reputation_cooldown = data['reputationCooldown']
      @account = data['account']
    end

    # Save the settings on this object
    # @return [ReputationSettings] the class itself
    def save
      WeebSh::API::Shimakaze.set_settings(@interface, {
        reputationPerDay: @reputation_per_day,
        maximumReputation: @max_reputation,
        maximumReputationReceivedDay: @max_reputation_per_day,
        reputationCooldown: @reputation_cooldown
      })
      self
    end

    # @!visibility private
    def inspect
      "#<WeebSh::ReputationSettings @reputation_per_day=#{@reputation_per_day.inspect} @max_reputation=#{@max_reputation.inspect} @max_reputation_per_day=#{@max_reputation_per_day.inspect} @reputation_cooldown=#{@reputation_cooldown.inspect}>"
    end
  end
end
