module Rowling
  module Configuration
    CONFIGURATION_KEYS = [:api_key, :raw]

    attr_accessor *CONFIGURATION_KEYS

    def self.extended(base)
      base.reset
    end

    def reset
      self.api_key = nil
      self.raw = false
    end

    def configure
      yield self
    end
  end
end
