require 'weeb/api/toph'
require 'weeb/data'

module WeebSh
  # Image API
  class Toph < Interface
    # Uploads an image.
    # @param resource [File, String] the file to upload, this can either be a File, a URL or a path.
    # @param type [String] the type of image this is in.
    # @param hidden [true, false] whether or not this image will be only seen to the uploader.
    # @param tags [Array<String, Tag>] the tags that this image applies to.
    # @param nsfw [true, false] whether or not this image is NSFW.
    # @param source [String] the source URL of the image
    # @return [Image] Returns image that was uploaded.
    def upload(resource, type, hidden: false, tags: [], nsfw: false, source: nil)
      tags = tags.map { |t| t.name if t.is_a(Tag) }
      if resource.is_a?(String) && URI(resource).host.nil?
        begin
          resource = File.new(File.absolute_path(resource), 'rb')
        rescue Errno::ENOENT, Errno::EACCES, Errno::ENAMETOOLONG => e
          errstring = 'Unknown'
          case e.class.name
          when 'Errno::ENOENT'
            errstring = 'File Not Found'
          when 'Errno::EACCES'
            errstring = 'Permission Denied'
          when 'Errno::ENAMETOOLONG'
            errstring = 'Name Too Long'
          end
          raise WeebSh::Err::FileError, "Error initializing file '${resource}' | #{errstring} | #{e.class.name}"
        end
      end

      Image.new(API::Toph.upload(self, resource, type, hidden, tags, nsfw, source)['file'], self)
    end

    # Gets a list of available types of images.
    # @param preview [true, false] whether or not to return an array ofpreview images instead of and array of strings
    # @param hidden [true, false] if true, you only get back hidden preview images you uploaded
    # @param nsfw [true, false, String] whether or not preview images could be NSFW. Setting this to "only" restricts it to NSFW images.
    # @return [Array<String>, Array<PreviewImage>] Returns all available types.
    def types(hidden: false, nsfw: false, preview: false)
      response = API::Toph.types(self, {
        hidden: hidden,
        nsfw: nsfw,
        preview: preview
      })
      preview ? response['preview'].map { |p| PreviewImage.new(p, self) } : response['types']
    end

    # Gets a list of available types of images.
    # @param hidden [true, false] if true, you only get back hidden tags you added
    # @param nsfw [true, false, String] whether or not preview images could be NSFW. Setting this to "only" restricts it to NSFW images.
    # @return [Array<String>, Array<PreviewImage>] Returns all available tags.
    def tags(hidden: false, nsfw: false)
      API::Toph.types(self, {
        hidden: hidden,
        nsfw: nsfw
      })['tags']
    end

    # Get a random image based on type or a set of tags.
    # @param type [String] the type of images to recieve
    # @param tags [Array<String, Tag>] the tags a image should require to be for selection
    # @param hidden [true, false] if true, you can only get back hidden tags you added
    # @param nsfw [true, false, String] whether or not preview images could be NSFW. Setting this to "only" restricts it to NSFW images.
    # @param file_type [String] the file type an image is required to be for selection
    # @return [WeebImage] Returns image that was randomly selected.
    def random(type: nil, tags: [], hidden: false, nsfw: false, file_type: nil)
      tags = tags.map { |t| t.name if t.is_a(Tag) }
      WeebImage.new(API::Toph.random(self, {
        type: type,
        tags: tags,
        hidden: hidden,
        nsfw: nsfw,
        file_type: file_type
      }), self)
    end

    # Get an image.
    # @param id [String, WeebImage, PreviewImage, #resolve_id] the image's ID to recieve
    # @return [WeebImage] Returns the image with the given ID.
    def image(id)
      id = id.resolve_id if id.respond_to?(:resolve_id)
      WeebImage.new(API::Toph.image(self, id), self)
    end

    # Delete an image.
    # @param id [String, WeebImage, PreviewImage, #resolve_id] the image's ID to delete
    # @return [WeebImage] Returns the image with the given ID.
    def delete_image(id)
      id = id.resolve_id if id.respond_to?(:resolve_id)
      WeebImage.new(API::Toph.delete_image(self, id), self)
    end
    alias_method :remove_image, :delete_image

    # Add tags to an image.
    # @param image [String, WeebImage, PreviewImage, #resolve_id] the image being referred
    # @param tags [Array<String, Tag>] the affected tags
    # @return [WeebImage] Returns the image with the given ID.
    def add_tags_to_image(image, tags)
      image = image.resolve_id if image.respond_to?(:resolve_id)
      tags = tags.map { |t| t.name if t.is_a(Tag) }
      WeebImage.new(API::Toph.add_tags_to_image(self, image, tags), self)
    end

    # Remove tags off of an image.
    # @param image [String, WeebImage, PreviewImage, #resolve_id] the image being referred
    # @param tags [Array<String, Tag>] the affected tags
    # @return [WeebImage] Returns the image with the given ID.
    def remove_tags_to_image(image, tags)
      image = image.resolve_id if image.respond_to?(:resolve_id)
      tags = tags.map { |t| t.name if t.is_a(Tag) }
      WeebImage.new(API::Toph.remove_tags_to_image(self, image, tags), self)
    end

    # Get a list of images based on arguments.
    # @param type [String] the type of images to recieve
    # @param tags [Array<String, Tag>] the tags a image should require to be for selection
    # @param hidden [true, false] if true, you can only get back hidden tags you added
    # @param nsfw [true, false, String] whether or not preview images could be NSFW. Setting this to "only" restricts it to NSFW images.
    # @param file_type [String] the file type an image is required to be for selection
    # @param page [Integer] the page number of images to use
    # @param account [String] the account ID to get images from
    # @return [WeebImage] Returns image that was randomly selected.
    def list(type: nil, tags: [], hidden: false, nsfw: false, file_type: nil, page: 0, account: nil)
      tags = tags.map { |t| t.name if t.is_a(Tag) }
      object = {
        type: type,
        tags: tags,
        hidden: hidden,
        nsfw: nsfw,
        file_type: file_type,
        page: page
      }
      repsonse = account ? API::Toph.list_user(self, account, object) : API::Toph.list(self, object)
      repsonse.map { |i| WeebImage.new(i, self) }
    end
  end

  # Alias for the class {Toph}
  Images = Toph
end
