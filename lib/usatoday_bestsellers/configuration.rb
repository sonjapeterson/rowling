module UsatodayBestsellers
  module Configuration
    DEFAULT_FORMAT = :json
    CONFIGURATION_KEYS = [:api_key, :format]

    attr_accessor *CONFIGURATION_KEYS

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
