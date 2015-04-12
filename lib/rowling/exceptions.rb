module Rowling
  class Response503Error < StandardError
    def message
      "Service temporarily unavailable."
    end
  end

  class Response403Error < StandardError
    def message
      "Exceeded quota per second"
    end
  end

  class NoAPIKeyError < StandardError
    def message
      "You must set a valid API key before making requests"
    end
  end

  class ResponseError < StandardError; end
  
end