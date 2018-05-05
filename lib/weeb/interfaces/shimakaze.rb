require 'weeb/api/shimakaze'
require 'weeb/data'

module WeebSh
  # Reputation API
  class Shimakaze < Interface
    # Makes a class with your bot ID to do requests easier
    # @param bot [String] the ID of the bot
    # @return [ShimakazeBot] the bot class
    def bot(bot)
      ShimakazeBot.new(bot, self)
    end

    # Get's a user
    # @param bot [String] the ID of the bot
    # @Param user [User, String, #resolve_id] the user to get
    # @return [User] the user requested
    def get(bot, user)
      user_id = user.resolve_id if user.respond_to?(:resolve_id)
      response = API::Shimakaze.get(self, bot, user_id || user)
      user.patch(response['user']) if user.is_a?(User)
      new User(response['user'], self)
    end

    # Gets the currentyly used settings
    # @return [ReputationSettings] the user requested
    def settings
      new ReputationSettings(response['settings'], self)
    end
  end

  # Bot class for shimakaze
  class ShimakazeBot
    include IDObject

    # @!visibility private
    def initialize(id, interface)
      @interface = interface
      @id = id
    end

    # Get's a user
    # @Param user [User, String, #resolve_id] the user to get
    # @return [User] the user requested
    def get(user)
      @interface.get(@id, user)
    end
  end
end
