module WeebSh
  # Custom errors raised in various places
  module Err
    # Raised when a token is invalid or incorrect.
    class BadAuth < RuntimeError
      def message
        'Token invalid'
      end
    end

    # Raised when too many files were uploaded.
    class MissingScope < RuntimeError
      def message
        'Too many files requested!'
      end
    end

    # Raised when a server error occurs
    class ServerFail < RuntimeError
      def message
        'Server tried to do a thing and borked!'
      end
    end

    # Raised when requested file(s) have too much bytes.
    class TooLarge < RuntimeError
      def message
        'File(s) are too large!'
      end
    end

    # Raised when an invalid mime type was given.
    class InvalidMIME < RuntimeError
      def message
        'You gave an unsupported MIME type!'
      end
    end

    # Raised when trying to add an existing tag to an image
    class TagExists < RuntimeError
      def message
        'Tags existed already or had no content!'
      end
    end

    # Raised when trying to interact with a non-existant image
    class InvalidImage < RuntimeError
      def message
        'Non-existant image!'
      end
    end

    # Raised when loading a file recieves an error
    class FileError < RuntimeError
      def message
        'Unknown'
      end
    end
  end
end
