require 'httparty'

module Rowling
  class Client
    include HTTParty

    attr_accessor *Configuration::CONFIGURATION_KEYS

    def initialize(options={})
      Configuration::CONFIGURATION_KEYS.each do |key|
        send("#{key}=", options[key])
      end
    end

    def get_classes(options={})
      class_response = HTTParty.get("http://api.usatoday.com/open/bestsellers/books/classes/?api_key=#{self.api_key}")
      class_response["Classes"]
    end
  end
end
