module WeebSh
  # Custom errors raised in various places
  module Err
    # Raised when a token is invalid or incorrect.
    class BadAuth < RuntimeError
      # The default message for the error
      def message
        'Token invalid'
      end
    end

    # Raised when too many files were uploaded.
    class MissingScope < RuntimeError
      # The default message for the error
      def message
        'Too many files requested!'
      end
    end

    # Raised when a server error occurs
    class ServerFail < RuntimeError
      # The default message for the error
      def message
        'Server tried to do a thing and borked!'
      end
    end

    # Raised when requested file(s) have too much bytes.
    class TooLarge < RuntimeError
      # The default message for the error
      def message
        'File(s) are too large!'
      end
    end

    # Raised when an invalid mime type was given.
    class InvalidMIME < RuntimeError
      # The default message for the error
      def message
        'You gave an unsupported MIME type!'
      end
    end

    # Raised when trying to add an existing tag to an image
    class TagExists < RuntimeError
      # The default message for the error
      def message
        'Tags existed already or had no content!'
      end
    end

    # Raised when trying to interact with a non-existant image
    class InvalidImage < RuntimeError
      # The default message for the error
      def message
        'Non-existant image!'
      end
    end

    # Raised when loading a file recieves an error
    class FileError < RuntimeError
      # The default message for the error
      def message
        'Unknown'
      end
    end
  end
end
