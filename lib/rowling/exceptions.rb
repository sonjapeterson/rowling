module Rowling
  class Response503Error < StandardError
    def message
      "Service temporarily unavailable."
    end
  end

  class Response400Error < StandardError
    def message
      "Bad request (data not found)."
    end
  end

  class Response403Error < StandardError
    def message
      "Exceeded quota per second/api rate limit"
    end
  end

  class NoAPIKeyError < StandardError
    def message
      "You must set a valid API key before making requests"
    end
  end

  class ResponseError < StandardError; end
  
end
