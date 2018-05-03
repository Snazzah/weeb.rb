require 'weeb/api'

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

    # @param token [String] the token required to use weeb.sh.
    # @param user_agent [String, Hash] the user agent to use on endpoints.
    # @param api_url [String] the URL to use when using the weeb.sh API.
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
    # @param tags [String, Tag] the affected tag
    def remove_tag(tag)
      @interface.remove_tags_to_image(self, [tag])
    end

    # Delete this image
    def delete
      @interface.delete_image(self)
    end
    alias_method :remove, :delete

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

    def inspect
      "#<WeebSh::Tag @name=#{@name.inspect} @hidden=#{@hidden.inspect} @account=#{@account.inspect}>"
    end
  end
end
