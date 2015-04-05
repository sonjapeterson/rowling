module UsatodayBestsellers
  module Configuration
    DEFAULT_FORMAT = :json

    attr_accessor :format, :api_key

    def self.extended(base)
      base.reset
    end

    def reset
      self.api_key = nil
      self.format = :json
    end

    def configure
      yield self
    end
  end
end
