
module Rowling
  class Client
    include HTTParty

    attr_accessor *Configuration::CONFIGURATION_KEYS

    def initialize(options={})
      Configuration::CONFIGURATION_KEYS.each do |key|
        send("#{key}=", options[key])
      end
    end

    def base_template
      template = Addressable::Template.new("http://api.usatoday.com/open/bestsellers/books{/segments*}{?query*}")
    end

    def get_classes(options={})
      options[:api_key] = self.api_key
      url = base_template.expand({
        segments: "classes",
        query: options})
      class_response = HTTParty.get(url)
      class_response["Classes"]
    end

    def get_book(options={})
      options[:api_key] = self.api_key
      isbn = options.delete(:isbn)
      segments = ["titles"]
      segments << isbn if isbn
      url = base_template.expand({
        segments: segments,
        query: options})
      book_response = HTTParty.get(url)
      Rowling::Book.new(book_response)
    end
  end
end
